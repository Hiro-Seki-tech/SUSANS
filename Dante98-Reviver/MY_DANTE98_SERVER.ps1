$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8765
$baseUrl = "http://127.0.0.1:$port/"

function Get-MimeType([string]$path) {
    switch ([System.IO.Path]::GetExtension($path).ToLowerInvariant()) {
        '.html' { 'text/html; charset=utf-8' }
        '.htm'  { 'text/html; charset=utf-8' }
        '.js'   { 'text/javascript; charset=utf-8' }
        '.mjs'  { 'text/javascript; charset=utf-8' }
        '.json' { 'application/json; charset=utf-8' }
        '.wasm' { 'application/wasm' }
        '.css'  { 'text/css; charset=utf-8' }
        '.bmp'  { 'image/bmp' }
        '.png'  { 'image/png' }
        '.jpg'  { 'image/jpeg' }
        '.jpeg' { 'image/jpeg' }
        '.gif'  { 'image/gif' }
        '.svg'  { 'image/svg+xml' }
        '.wav'  { 'audio/wav' }
        '.mp3'  { 'audio/mpeg' }
        '.zip'  { 'application/zip' }
        '.d88'  { 'application/octet-stream' }
        '.com'  { 'application/octet-stream' }
        '.exe'  { 'application/octet-stream' }
        '.dat'  { 'application/octet-stream' }
        default { 'application/octet-stream' }
    }
}

function Write-Response($stream, [int]$status, [string]$statusText, [byte[]]$body, [string]$contentType, [bool]$headOnly = $false) {
    $header = "HTTP/1.1 $status $statusText`r`n" +
              "Content-Type: $contentType`r`n" +
              "Content-Length: $($body.Length)`r`n" +
              "Cache-Control: no-store`r`n" +
              "Connection: close`r`n`r`n"
    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $stream.Write($headerBytes, 0, $headerBytes.Length)
    if (-not $headOnly -and $body.Length -gt 0) {
        $stream.Write($body, 0, $body.Length)
    }
    $stream.Flush()
}

$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $port)
try {
    $listener.Start()
} catch {
    # A previous MY DANTE98 server is probably already running. Reuse it instead of showing an error.
    try {
        Start-Process $baseUrl
        exit 0
    } catch {
        Write-Host ""
        Write-Host "MY DANTE98 could not start the local web server." -ForegroundColor Red
        Write-Host "Port $port is already in use by another application." -ForegroundColor Yellow
        Read-Host "Press Enter to close"
        exit 1
    }
}

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host " MY DANTE98 local web server is running" -ForegroundColor Cyan
Write-Host " $baseUrl" -ForegroundColor Green
Write-Host ""
Write-Host " Keep this window open while using MY DANTE98." -ForegroundColor Yellow
Write-Host " Close this window when you finish." -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Cyan

# Prefer Chrome when installed; otherwise use the Windows default browser.
$chromeCandidates = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)
$chrome = $chromeCandidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
Start-Sleep -Milliseconds 350
if ($chrome) {
    Start-Process -FilePath $chrome -ArgumentList $baseUrl
} else {
    Start-Process $baseUrl
}

$rootFull = [System.IO.Path]::GetFullPath($root).TrimEnd('\') + '\'

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $stream = $client.GetStream()
            $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::ASCII, $false, 4096, $true)
            $requestLine = $reader.ReadLine()
            if ([string]::IsNullOrWhiteSpace($requestLine)) {
                $client.Close(); continue
            }
            while ($true) {
                $line = $reader.ReadLine()
                if ([string]::IsNullOrEmpty($line)) { break }
            }

            $parts = $requestLine.Split(' ')
            if ($parts.Length -lt 2) {
                $body = [System.Text.Encoding]::UTF8.GetBytes('Bad Request')
                Write-Response $stream 400 'Bad Request' $body 'text/plain; charset=utf-8'
                continue
            }
            $method = $parts[0].ToUpperInvariant()
            if ($method -ne 'GET' -and $method -ne 'HEAD') {
                $body = [System.Text.Encoding]::UTF8.GetBytes('Method Not Allowed')
                Write-Response $stream 405 'Method Not Allowed' $body 'text/plain; charset=utf-8'
                continue
            }

            $rawPath = $parts[1].Split('?')[0]
            if ($rawPath -eq '/__my_dante98_shutdown__') {
                $body = [System.Text.Encoding]::UTF8.GetBytes('OK')
                Write-Response $stream 200 'OK' $body 'text/plain; charset=utf-8' ($method -eq 'HEAD')
                $client.Close()
                break
            }
            $decoded = [System.Uri]::UnescapeDataString($rawPath)
            if ($decoded -eq '/') { $decoded = '/index.html' }
            $relative = $decoded.TrimStart('/').Replace('/', '\')
            $candidate = [System.IO.Path]::GetFullPath((Join-Path $root $relative))

            if (-not $candidate.StartsWith($rootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
                $body = [System.Text.Encoding]::UTF8.GetBytes('Forbidden')
                Write-Response $stream 403 'Forbidden' $body 'text/plain; charset=utf-8' ($method -eq 'HEAD')
                continue
            }

            if ((Test-Path $candidate -PathType Container)) {
                $candidate = Join-Path $candidate 'index.html'
            }

            if (-not (Test-Path $candidate -PathType Leaf)) {
                $body = [System.Text.Encoding]::UTF8.GetBytes('Not Found')
                Write-Response $stream 404 'Not Found' $body 'text/plain; charset=utf-8' ($method -eq 'HEAD')
                continue
            }

            $bytes = [System.IO.File]::ReadAllBytes($candidate)
            Write-Response $stream 200 'OK' $bytes (Get-MimeType $candidate) ($method -eq 'HEAD')
        } catch {
            try {
                $body = [System.Text.Encoding]::UTF8.GetBytes('Internal Server Error')
                Write-Response $stream 500 'Internal Server Error' $body 'text/plain; charset=utf-8'
            } catch {}
        } finally {
            $client.Close()
        }
    }
} finally {
    $listener.Stop()
}
