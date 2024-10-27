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

  ags.enable = true;
  ags.aylur.enable = false;
  # ags.hyprpanel.enable = true;
  apps.foot.enable = true;
  apps.alacritty.enable = true;
  apps.firefox = {
    enable = true;
    profileName = "Default";
    arkenfox = true;
  };
  apps.zathura.enable = true;
  cli.yazi.enable = true;
  cli.zellij.enable = true;
  cli.zsh.enable = true;
  env.enable = true;
  hypr = {
    hyprland = {
      enable = true;
      hostname = hostname;
      barcmd = "ags &";
    };
    hyprlock.enable = true;
    hypridle.enable = true;
    pyprland.enable = true;
    wlogout.enable = true;
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

  waybar.enable = true;

}
