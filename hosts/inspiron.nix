# Dell Inspiron 15 7000 configuration
{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "nixabyss-inspiron";

  # Hardware-specific settings
  hardware = {
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        libvdpau-va-gl
      ];
    };
    bluetooth.enable = true;
  };

  # Power management
  services = {
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_BAT = 0;
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    throttled.enable = true;  # Intel CPU throttling daemon
  };

  # Touchpad configuration
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      accelSpeed = "0.6";
      disableWhileTyping = true;
    };
  };

  # Display and graphics
  services.xserver = {
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
  };

  # Boot configuration
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ 
      "intel_pstate=active"
      "i915.enable_psr=0"  # Fix for potential screen flickering
    ];
    kernelModules = [ "kvm-intel" ];
  };

  # Additional system packages specific to this machine
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    powertop
    s-tui  # Terminal UI for monitoring CPU
    lm_sensors
  ];
}