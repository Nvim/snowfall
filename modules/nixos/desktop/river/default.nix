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
        river-filtile
        wl-color-picker
        libsForQt5.qt5ct
        swaybg
        slurp
        grim
        wf-recorder
        wl-clipboard
        wlr-randr
        pcmanfm
      ];
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
