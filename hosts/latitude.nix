# Dell Latitude E7440 configuration
{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  networking.hostName = "nixabyss-latitude";

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

  # Power management optimized for older hardware
  services = {
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_BAT = 0;
        SATA_LINKPWR_ON_BAT = "min_power";
        WIFI_PWR_ON_BAT = "on";
        START_CHARGE_THRESH_BAT0 = 85;  # Conservative battery threshold for older battery
        STOP_CHARGE_THRESH_BAT0 = 90;
      };
    };
    # Additional cooling management for older hardware
    thinkfan.enable = true;
  };

  # Touchpad configuration for older hardware
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      accelSpeed = "0.4";  # Slower acceleration for older touchpad
      disableWhileTyping = true;
      scrollMethod = "twofinger";
    };
  };

  # Display and graphics - optimized for older Intel
  services.xserver = {
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "2"  # Using DRI2 for better compatibility
      Option "AccelMethod" "sna"
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
      "intel_pstate=passive"  # Better for older Intel CPUs
      "i915.enable_rc6=1"     # Power-saving features
      "i915.enable_fbc=1"     # Framebuffer compression
    ];
    kernelModules = [ "kvm-intel" ];
    # Use zen kernel for better performance on older hardware
    kernelPackages = pkgs.linuxPackages_zen;
  };

  # Additional system packages specific to this machine
  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    powertop
    s-tui
    lm_sensors
    cpupower-gui  # GUI for CPU frequency management
    thermald
  ];

  # Lower resource usage for older hardware
  services.xserver.displayManager.sessionOptions = [
    "--xrender-sync"
    "--xrender-sync-fence"
  ];
}