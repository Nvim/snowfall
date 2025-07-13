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
  programs.mangohud.enable = true;
  xdg.enable = true;
  snowfallorg.user.name = username;
  programs.home-manager.enable = true;
  home.stateVersion = stateVersion;

  theming.qt.enable = false;

  ags.enable = false;
  waybar.enable = false;
  apps.foot = {
    enable = true;
    server = false;
  };
  apps.alacritty.enable = true;
  apps.firefox = {
    enable = true;
    profileName = "BetterFox";
  };
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
    defaultDisplay = "DP-3";
    basic.enable = true;
    wayland.enable = true;
    x11.enable = false;
    autobisync-service.enable = true;
  };

  tools = {
    distrobox.enable = true;
    direnv.enable = true;
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
