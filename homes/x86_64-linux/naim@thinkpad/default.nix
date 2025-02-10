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
      barcmd = "my-shell &";
      menucmd = "${pkgs.tofi}/bin/tofi-drun";
    };
    hyprlock.enable = true;
    hypridle.enable = true;
    pyprland.enable = true;
    wlogout.enable = true;
  };
  scripts = {
    dmenucmd = "${pkgs.tofi}/bin/tofi";
    # dmenucmd = "${pkgs.rofi-wayland}/bin/rofi";
    basic.enable = true;
    wayland.enable = true;
    x11.enable = false;
    autobisync-service.enable = true;
  };

  tools = {
    direnv.enable = true;
    rofi.enable = true;
    tofi.enable = true;
    stylix.enable = true;
    stylix.hostname = hostname;
  };

  waybar.enable = true;

}
