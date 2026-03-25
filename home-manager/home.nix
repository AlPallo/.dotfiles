{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "alex";
  home.homeDirectory = "/home/alex";

	home.sessionVariables = {
			ANSIBLE_VAULT_PASSWORD_FILE = "$HOME/.ansible-vault.key";
			ANSIBLE_HOME = "$HOME/.cache/ansible";
			EDITOR = "nvim";
			MANPAGER = "nvim +Man!";
			PGPASSFILE = "$HOME/.pgpass";
			DOCKER_CONFIG = "$HOME/.ldocker";
		};

	home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "/usr/local/inotify-tools/bin"
  ];
   # Packages that should be installed to the user profile.

  home.packages = with pkgs; [
		python314
    fzf
    git
		nodejs_25
    fd
		ripgrep
		neovim
		lua-language-server
		pipx
		ansible-lint
		autoflake
		black
		djhtml
		djlint
		isort
		pgcli
		ruff
		tmux
		prettier
		prettierd
		vtsls
		bash-language-server
		fish-lsp
		pyright
		vscode-langservers-extracted
		yaml-language-server
		redis
		iredis
		stow
		unzip
		tree
		rustup
		go
		ansible
		docker
		docker-compose
		gcc
		openssh
		fish
		tree-sitter
		cmake
		cmatrix
		htop
		ninja
		nmap
		postgresql_16
		shellcheck
		shfmt
		wget
		openssl
		jq
		luajit
    luajitPackages.luarocks
  ];

	programs.fish = {
    enable = true;
		interactiveShellInit = ''
      # Keybinds
      bind \cy accept-autosuggestion

      # Git
      set -g __fish_git_prompt_show_informative_status 1
      set -g __fish_git_prompt_char_stagedstate "+"
      set -g __fish_git_prompt_color_stagedstate green
      set -g __fish_git_prompt_char_dirtystate "*"
      set -g __fish_git_prompt_color_dirtystate red
      set -g __fish_git_prompt_char_cleanstate ""
      set -g __fish_git_prompt_char_conflictedstate "!"
      set -g __fish_git_prompt_color_conflictedstate red
      set -g __fish_git_prompt_color_branch magenta
      set -g __fish_git_prompt_char_untrackedfiles "…"

      # CLI Colors
      set -g fish_color_autosuggestion brblack
      set -g fish_color_cancel -r
      set -g fish_color_command blue
      set -g fish_color_comment red
      set -g fish_color_cwd white
      set -g fish_color_cwd_root red
      set -g fish_color_end green
      set -g fish_color_error brred
      set -g fish_color_escape brcyan
      set -g fish_color_history_current --bold
      set -g fish_color_host normal
      set -g fish_color_host_remote brblue
      set -g fish_color_normal normal
      set -g fish_color_operator brcyan
      set -g fish_color_param cyan
      set -g fish_color_quote yellow
      set -g fish_color_redirection cyan --bold
      set -g fish_color_search_match bryellow --background=brblack
      set -g fish_color_selection white --bold --background=brblack
      set -g fish_color_status red
      set -g fish_color_user brgreen
      set -g fish_color_valid_path --underline

      set -g fish_greeting ""

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
    '';
	};

  xdg.configFile."fish/functions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fish/functions";
  xdg.configFile."fish/completions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fish/completions";
  xdg.configFile."fish/conf.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fish/conf.d";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
