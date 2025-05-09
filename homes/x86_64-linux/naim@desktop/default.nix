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
  waybar.enable = true;
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
      enable = true;
      hostname = hostname;
      barcmd = "waybar &";
      menucmd = "tofi-drun";
    };
    hyprlock.enable = true;
    hypridle.enable = true;
    pyprland.enable = true;
    wlogout.enable = true;
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
    tofi.enable = true;
    direnv.enable = true;
    rofi.enable = true;
    stylix.enable = true;
    stylix.hostname = hostname;
  };
}
