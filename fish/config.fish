if status is-interactive
  # Git
  set -U __fish_git_prompt_show_informative_status 1
  set -U __fish_git_prompt_char_stagedstate "+"
  set -U __fish_git_prompt_color_stagedstate green
  set -U __fish_git_prompt_char_dirtystate "*"
  set -U __fish_git_prompt_color_dirtystate red
  set -U __fish_git_prompt_char_cleanstate ""
  set -U __fish_git_prompt_char_conflictedstate "!"
  set -U __fish_git_prompt_color_conflictedstate red
  set -U __fish_git_prompt_color_branch magenta
  set -U __fish_git_prompt_char_untrackedfiles "…"

  # CLI Colors
  set -U fish_color_autosuggestion brblack
  set -U fish_color_cancel -r
  set -U fish_color_command blue
  set -U fish_color_comment red
  set -U fish_color_cwd white
  set -U fish_color_cwd_root red
  set -U fish_color_end green
  set -U fish_color_error brred
  set -U fish_color_escape brcyan
  set -U fish_color_history_current --bold
  set -U fish_color_host normal
  set -U fish_color_host_remote brblue
  set -U fish_color_normal normal
  set -U fish_color_operator brcyan
  set -U fish_color_param cyan
  set -U fish_color_quote yellow
  set -U fish_color_redirection cyan --bold
  set -U fish_color_search_match bryellow --background=brblack
  set -U fish_color_selection white --bold --background=brblack
  set -U fish_color_status red
  set -U fish_color_user brgreen
  set -U fish_color_valid_path --underline

  # Vars
  set -Ux ANSIBLE_VAULT_PASSWORD_FILE "$HOME/.ansible-vault.key"
  set -Ux EDITOR nvim
  set -Ux MANPAGER "nvim +Man!"
  set -Ux PGPASSFILE "$HOME/.pgpass"
  set -Ux DOCKER_CONFIG $HOME/.ldocker
  set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths
  set -U fish_user_paths $HOME/.local/bin $fish_user_paths

  set -U fish_greeting ""

  # Tmux ssh auth sock
  set sock "/tmp/ssh-agent-$USER-screen"
  if test -n "$SSH_AUTH_SOCK"
    if test "$SSH_AUTH_SOCK" != "$sock"
      rm -f "$sock"
      ln -sf "$SSH_AUTH_SOCK" "$sock"
      set -gx SSH_AUTH_SOCK "$sock"
    end
  end

  # Tmux auto-start
  if not set -q TMUX
    if tmux has-session 2>/dev/null
      tmux attach
    else
      tmux new -s main
    end
  end


end
