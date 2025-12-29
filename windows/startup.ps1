$komorebiExe = "komorebic.exe"

while ($true) {
    & $komorebiExe state *> $null
    if ($LASTEXITCODE -eq 0) { break }
    Start-Sleep -Seconds 1
}

Start-Sleep -Seconds 2

komorebic.exe workspace-rule exe "Spotify.exe" 0 0
komorebic.exe workspace-rule exe "ms-teams.exe" 0 0
komorebic.exe workspace-rule exe "alacritty.exe" 0 1
komorebic.exe workspace-rule exe "brave.exe" 0 2
komorebic.exe workspace-rule exe "Discord.exe" 0 3

Start-Process "spotify:"
Start-Sleep -Seconds 2

Start-Process "ms-teams" 
Start-Sleep -Seconds 2

Start-Process "alacritty"
Start-Sleep -Seconds 2

Start-Process "brave"
Start-Sleep -Seconds 2

Start-Process "$Env:LOCALAPPDATA\Discord\Update.exe" -ArgumentList "--processStart Discord.exe"
Start-Sleep -Seconds 5

komorebic.exe retile
Start-Sleep -Seconds 60
komorebic.exe clear-all-workspace-rules
