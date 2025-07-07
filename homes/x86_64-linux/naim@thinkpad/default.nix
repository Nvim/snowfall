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
    server = false;
  };
  apps.alacritty.enable = false;
  apps.firefox = {
    enable = true;
    profileName = "BetterFox";
  };
  apps.ghostty.enable = false;
  apps.wezterm.enable = true;
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
    # dmenucmd = "${pkgs.rofi-wayland}/bin/rofi";
    basic.enable = true;
    wayland.enable = true;
    x11.enable = false;
    autobisync-service.enable = true;
  };

  tools = {
    direnv.enable = true;
    distrobox.enable = true;
    rofi.enable = true;
    stylix.enable = true;
    stylix.hostname = hostname;
    tofi.enable = true;
  };

  wayland = {
    i3bar-river.enable = true;
    i3status-rust.enable = true;
    river.enable = true;
    swayidle.enable = true;
    swaylock.enable = true;
  };
}
