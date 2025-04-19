# Common configuration shared across all hosts
{ config, lib, pkgs, ... }: {
  # Enable flakes and experimental features
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Basic system configuration
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # Display manager and desktop environment
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          Theme = {
            Current = "breeze";
            CursorTheme = "Adwaita";
          };
        };
      };
    };
    desktopManager.gnome.enable = true;
  };

  # Audio configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # Network configuration
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
      allowPing = true;
    };
  };

  # System packages common to all machines
  environment.systemPackages = with pkgs; [
    # System utilities
    git
    curl
    wget
    vim
    htop
    neofetch
    
    # Development
    gcc
    gnumake
    python3
    
    # Desktop environment
    wofi
    waybar
    dunst
    libnotify
    wl-clipboard
    
    # Multimedia
    brightnessctl
    playerctl
    pamixer
    
    # File management
    ranger
    p7zip
    unzip
    file
    
    # System monitoring
    lm_sensors
    smartmontools
  ];

  # Font configuration
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # User configuration
  users.users.aaron = {
    isNormalUser = true;
    description = "aaron";
    extraGroups = [ 
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
    initialPassword = "changeme";
  };

  # Security
  security.sudo.wheelNeedsPassword = true;

  # System state version
  system.stateVersion = "24.11";
}