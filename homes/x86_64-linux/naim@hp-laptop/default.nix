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
  xdg.enable = true;
  snowfallorg.user.name = username;
  programs.home-manager.enable = true;
  home.stateVersion = stateVersion;

  ags.enable = false;
  ags.aylur.enable = false;
  # ags.hyprpanel.enable = true;
  apps.foot.enable = true;
  apps.alacritty.enable = true;
  apps.firefox = {
    enable = true;
    arkenfox = true;
  };
  cli.yazi.enable = true;
  cli.zellij.enable = true;
  cli.zsh.enable = true;
  env.enable = true;
  hypr = {
    hyprland.enable = false;
    hyprland.hostname = hostname;
    hyprlock.enable = false;
    hypridle.enable = false;
    pyprland.enable = false;
    wlogout.enable = false;
  };
  scripts = {
    basic.enable = true;
    wayland.enable = true;
    x11.enable = false;
  };

  tools = {
    direnv.enable = true;
    rofi.enable = true;
    stylix.enable = true;
    stylix.hostname = hostname;
  };
}
