{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.desktop.dwm;
in
{
  options.desktop.dwm = {
    enable = mkEnableOption "enable DWM";
  };
  config = mkIf cfg.enable {

    # Enable DWM:
    services.xserver = {
      # displayManager.startx.enable = true;
      windowManager.dwm = {
        enable = true;
        # package = pkgs.dwm.override { patches = [ ../../../dwm-azerty-6.2.diff ]; };
        # package = pkgs.dwm.overrideAttrs { src = /home/naim/dwm; };
      };
    };
    services.picom = {
      enable = true;
      fade = false;
      shadow = false;
    };
    services.libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };
    programs.slock.enable = true;
    systemd.services."slock-service" = {
      enable = true;
      wantedBy = [ "sleep.target" ];
      unitConfig = {
        Description = "Lock X session usin slock for user %i";
        Before = [ "sleep.target" ];
      };
      environment = {
        DISPLAY = ":0";
      };
      serviceConfig = {
        ExecStartPre = ''${pkgs.xorg.xset}/bin/xset dpms force suspend'';
        ExecStart = ''${pkgs.slock}/bin/xlock'';
      };
    };

    # Might allow xbacklight command to work, not tested
    # services.xserver.config = ''
    #   Section "Device"
    #   Identifier  "Intel Graphics" 
    #   Driver      "intel"
    #   Option      "Backlight"  "intel_backlight"
    #   EndSection
    # '';

    # Allows users in video group to control brightness
    hardware.brillo.enable = true;

    # pkgs for dwm (overkill?)
    environment.systemPackages = with pkgs; [
      flameshot
      dwmblocks
      lm_sensors # for sb-cpu -> TODO: bundle it in script
      xorg.xinit
      xorg.xrandr
      xorg.xmodmap
      xorg.xkill
      xorg.xhost
      xdo
      xdotool
      arandr
      xorg.xgamma
      libva
      libdrm
      st
      dmenu
      brillo # for brightness
      dunst
    ];
  };
}
