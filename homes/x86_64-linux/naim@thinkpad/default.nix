{
  lib,
  config,
  pkgs,
  username,
  hostname,
  stateVersion,
  ...
}:
with lib;
{
  home.packages = [
    pkgs.ghostty
  ];
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";

      "image/png"="org.xfce.ristretto.desktop";
      "image/jpeg"="org.xfce.ristretto.desktop";
      "image/wepb"="org.xfce.ristretto.desktop";
      "image/gif"="org.xfce.ristretto.desktop";

      "text/plain" = "nvim.desktop";
      "application/pdf" = "zathura.desktop";
    };
  };

  dconf.settings = {
    "org/gnome/mutter" = {
      check-alive-timeout = 60000;
    };
  };
  xdg.enable = true;
  snowfallorg.user.name = username;
  programs.home-manager.enable = true;
  home.stateVersion = stateVersion;

  theming.qt.enable = false;

  # ags.enable = true;
  waybar.enable = false;
  apps.foot = {
    enable = true;
    server = true;
  };
  apps.alacritty.enable = false;
  apps.firefox = {
    enable = true;
    profileName = "BetterFox";
  };
  apps.ghostty.enable = false;
  apps.wezterm.enable = false;
  apps.zathura.enable = true;
  cli = {
    neovim.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zellij.enable = false;
    zsh.enable = true;
  };
  env.enable = true;
  hypr = {
    hyprland = {
      enable = false;
      hostname = hostname;
      barcmd = "waybar &";
      menucmd = "tofi-drun";
    };
    hyprlock.enable = false;
    hypridle.enable = false;
    pyprland.enable = false;
    wlogout.enable = false;
  };
  scripts = {
    dmenucmd = "tofi";
    defaultDisplay = "eDP-1";
    # dmenucmd = "${pkgs.rofi-wayland}/bin/rofi";
    basic.enable = true;
    wayland.enable = true;
    x11.enable = false;
    autobisync-service.enable = true;
  };

  tools = {
    distrobox.enable = true;
    direnv.enable = true;
    mpd.enable = true;
    rofi.enable = false;
    stylix.enable = true;
    stylix.hostname = hostname;
    tofi.enable = true;
  };

  wayland = {
    i3bar-river.enable = true;
    i3status-rust.enable = true;
    river.enable = true;
    river.hostname = hostname;
    swayidle.enable = true;
    swaylock.enable = true;
  };
}
