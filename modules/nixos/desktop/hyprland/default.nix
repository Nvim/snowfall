# Hyprland NixOS module, needed for setup.
# Config is done in Home Manager module
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
  cfg = config.desktop.hyprland;
in
{
  options.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyprland NixOS module";
  };
  config = mkIf cfg.enable {

    programs.hyprland.enable = true;
    programs.dconf.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      WAYLAND_DISPLAY = "1";
    };

    environment.systemPackages = with pkgs; [
      swww
      hyprpaper
      hyprshade
      rofi-wayland
      wl-clipboard
      wf-recorder
      hyprpicker
      wayshot
      xdg-desktop-portal-hyprland
      qt5ct
      qt6ct
      # inputs.pyprland.packages."x86_64-linux".pyprland
    ];

    xdg = {
      portal = with pkgs; {
        enable = true;
        configPackages = [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
          xdg-desktop-portal
        ];
        extraPortals = [
          xdg-desktop-portal-gtk
          xdg-desktop-portal
        ];
        xdgOpenUsePortal = true;
      };
      # TODO: mime types
      # mime = {
      #   enable = true;
      #   defaultApplications = {
      #     "application/pdf" = "brave.desktop";
      #     "inode/directory" = "org.gnome.Nautilus.desktop";
      #
      #     # Plain text & code.
      #     "application/x-shellscript" = "neovim.desktop";
      #     "text/plain" = "neovim.desktop";
      #   };
      # };
    };

    # Enable gnome polkit 
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
    security.polkit.enable = true;
    security.pam.services.hyprlock = {
      unixAuth = true;
    };

    nix.settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
}
