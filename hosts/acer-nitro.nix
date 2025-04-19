# Acer Nitro 5 configuration with RTX 4060
{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "nixabyss-nitro";

  # Hardware-specific settings
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  # Boot configuration with separate partitions
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ 
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia-drm.modeset=1"
    ];
    kernelModules = [ "nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  # Display and graphics
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      Option "AllowIndirectGLXProtocol" "off"
      Option "TripleBuffer" "on"
    '';
  };

  # Power management
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false; # Conflicts with NVIDIA power management
    acpid.enable = true;
  };

  # NVIDIA-specific environment variables
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_DRM_NO_ATOMIC = "1";
    };
    systemPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      libva-utils
      vulkan-tools
      glxinfo
      nvtop
    ];
  };

  # Gaming optimizations
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable 32-bit support for Steam and gaming
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.driSupport32Bit = true;
}