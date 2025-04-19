# Intel laptop-specific Hyprland configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./hyprland-base.nix ];

  wayland.windowManager.hyprland = {
    settings = {
      # Intel-specific settings
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "WLR_DRM_DEVICES,/dev/dri/card0"
      ];

      # Common Intel laptop multimedia keys
      bind = [
        # Volume control using PipeWire
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +2%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -2%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        
        # Brightness control
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        
        # Media control
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Power-saving animations
      animations = {
        enabled = true;
        # Reduce animation complexity for better battery life
        animation = [
          "windows, 1, 3, default"
          "border, 1, 3, default"
          "fade, 1, 2, default"
          "workspaces, 1, 2, default"
        ];
      };
    };

    # Power management optimizations
    extraConfig = ''
      # Enable power-save mode by default
      exec-once = hyprctl keyword misc:vfr true
      
      # Reduce refresh rate on battery
      exec-once = ${pkgs.writeShellScript "battery-refresh-rate" ''
        while true; do
          if [ "$(cat /sys/class/power_supply/BAT*/status)" = "Discharging" ]; then
            hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
          else
            hyprctl keyword monitor eDP-1,1920x1080@75,0x0,1
          fi
          sleep 30
        done
      ''}
    '';
  };
}