$real ="Program Files\Alacritty\alacritty.exe"

$defaultArgs = @(
  "--config-file", "$env:USERPROFILE\.dotfiles\windows\alacritty\alacritty.toml",
  "--working-directory", "$env:USERPROFILE"
)

& $real @defaultArgs @args
