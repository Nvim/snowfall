{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.desktop.river;
in
{
  options.desktop.river = {
    enable = mkEnableOption "Enable River NixOS module";
  };
  config = mkIf cfg.enable {

    programs.river = {
      enable = true;
      xwayland.enable = false;
      extraPackages = with pkgs; [
        swaybg
        wl-clipboard
        wf-recorder
        libsForQt5.qt5ct
      ];
    };

    environment.sessionVariables = {
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    # xdg = {
    #   portal = with pkgs; {
    #     enable = true;
    #     configPackages = [
    #       xdg-desktop-portal-gtk
    #       xdg-desktop-portal
    #     ];
    #     extraPortals = [
    #       xdg-desktop-portal-gtk
    #       xdg-desktop-portal
    #     ];
    #     xdgOpenUsePortal = true;
    #   };
    # };

    # Enable gnome polkit
    # systemd = {
    #   user.services.polkit-gnome-authentication-agent-1 = {
    #     description = "polkit-gnome-authentication-agent-1";
    #     wantedBy = [ "graphical-session.target" ];
    #     wants = [ "graphical-session.target" ];
    #     after = [ "graphical-session.target" ];
    #     serviceConfig = {
    #       Type = "simple";
    #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #       Restart = "on-failure";
    #       RestartSec = 1;
    #       TimeoutStopSec = 10;
    #     };
    #   };
    # };
  };
}
