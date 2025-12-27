Start-Sleep -Seconds 5
Start-Process "komorebic.exe" -ArgumentList "start --whkd" -WindowStyle Hidden
Start-Sleep -Seconds 2

# Workspace 0 (I): Spotify, Teams
komorebic.exe initial-workspace-rule exe "Spotify.exe" 0 0
komorebic.exe initial-workspace-rule exe "ms-teams.exe" 0 0

# Workspace 1 (II): Alacritty
komorebic.exe initial-workspace-rule exe "alacritty.exe" 0 1

# Workspace 2 (III): Brave
komorebic.exe initial-workspace-rule exe "brave.exe" 0 2

# Workspace 3 (IV): Discord
komorebic.exe initial-workspace-rule exe "Discord.exe" 0 3
Start-Sleep -Seconds 5

Start-Process "spotify:"
Start-Sleep -Milliseconds 500

Start-Process "$Env:LOCALAPPDATA\Discord\Update.exe" -ArgumentList "--processStart Discord.exe"
Start-Sleep -Milliseconds 500

Start-Process "alacritty"
Start-Sleep -Milliseconds 500

Start-Process "brave"
Start-Sleep -Milliseconds 500

Start-Sleep -Seconds 90
komorebic.exe clear-all-workspace-rules
