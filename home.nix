# Main home-manager configuration
{ config, lib, pkgs, ... }:

let
  hostname = builtins.readFile "/etc/hostname";
  isNitro = hostname == "nixabyss-nitro";
  isLatitude = hostname == "nixabyss-latitude";
  isInspiron = hostname == "nixabyss-inspiron";
in
{
  imports = [
    ./modules/nvim.nix
  ] ++ (if isNitro then [ ./modules/hyprland-nitro.nix ]
    else if isLatitude then [ ./modules/hyprland-intel.nix ]
    else if isInspiron then [ ./modules/hyprland-intel.nix ]
    else [ ./modules/hyprland-base.nix ]);

  home = {
    username = "aaron";
    homeDirectory = "/home/aaron";
    stateVersion = "24.11";

    packages = with pkgs; [
      # Development
      git
      gh
      gnumake
      rustup
      gcc
      python3
      nodejs
      
      # Terminal utilities
      kitty
      zsh
      starship
      exa
      bat
      ripgrep
      fd
      fzf
      btop
      tmux
      
      # System tools
      brightnessctl
      playerctl
      pamixer
      grimblast
      wl-clipboard
      
      # Applications
      firefox
      vlc
      libreoffice
      zathura
      discord
      spotify
    ];
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "rust" "npm" ];
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Kitty terminal configuration
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono";
      font_size = 12;
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
    theme = "Catppuccin-Mocha";
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "aaron";
    userEmail = "your.email@example.com"; # Replace with your email
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable fonts
  fonts.fontconfig.enable = true;

  # Additional home-manager settings
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
