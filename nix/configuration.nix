# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:


let
  rustOverlay = builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";

# --- DECLARATIVE ZEN-CAL DEFINITION ---
  zen-cal = pkgs.buildGoModule rec {
    pname = "zen-cal";
    version = "unstable-2025-01-14";

    src = pkgs.fetchFromGitHub {
      owner = "beaterblank";
      repo = "zen-cal";
      rev = "master"; # You can pin this to a specific commit hash for stability
      hash = "sha256-dMcOM/Vs+0mFwO99mvQXw8Aejk3t98II2mSWW0NogBw=";
    };

    modRoot = "./src"; 
    postPatch = ''
      substituteInPlace src/go.mod --replace "go 1.25.5" "go 1.24"
    '';
    overrideModAttrs = (_: {
      preBuild = ''
        go mod tidy
      '';
    });

    vendorHash = "sha256-YeIUXCClNZzjLLsth8hvhTfi+Oes4bwHubRW4lsBOKI=";
  };
in

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ap-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  # in fonts.packages
  fonts.packages = [
          pkgs.nerd-fonts.caskaydia-cove
      ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  nix = { settings.experimental-features = [ "nix-command" ]; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  nixpkgs.overlays = [ (import rustOverlay) ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    python314
    rivercarro
    xwayland-satellite
    niri
    wlogout
    wlrctl
    zen-cal
    pgcli
    jq
    go
    spotify
    steam
    discord
    river-classic
    neovim
    rust-bin.nightly.latest.default
    stow
    brave
    vscode-langservers-extracted
    lua-language-server
    pyright
    git
    wget
    ripgrep
    fd
    fzf
    lua
    gnumake
    gcc
    unzip
    nodejs_24
    tmux
    nil
    docker_29
    waybar
    fuzzel
    foot
    river-bsp-layout
    river-bedload
    lswt
  ];

  systemd.user.services.waybar.enable = false;
  programs.fish.enable = true;
  programs.river-classic.enable = true;
  #programs.niri.enable = true;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "CaskaydiaCove Nerd Font:size=12";
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
