# Acer Nitro-specific Hyprland configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./hyprland-base.nix ];

  wayland.windowManager.hyprland = {
    settings = {
      # RTX 4060 specific settings
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];

      monitor = [
        "eDP-1, 1920x1080@144, 0x0, 1"
      ];

      # Gaming optimizations
      misc = {
        vfr = true;
        vrr = 1;
      };
    };

    # Nvidia-specific environment setup
    extraConfig = ''
      # Gaming mode toggle (disable animations and other effects)
      bind = $mainMod ALT, G, exec, ${pkgs.writeShellScript "gaming-mode" ''
        if [ -f /tmp/gaming_mode ]; then
          rm /tmp/gaming_mode
          hyprctl keyword animations:enabled 1
          hyprctl keyword decoration:blur:enabled 1
          notify-send "Gaming Mode Disabled" "Visual effects restored"
        else
          touch /tmp/gaming_mode
          hyprctl keyword animations:enabled 0
          hyprctl keyword decoration:blur:enabled 0
          notify-send "Gaming Mode Enabled" "Visual effects disabled for better performance"
        fi
      ''}
    '';
  };
}