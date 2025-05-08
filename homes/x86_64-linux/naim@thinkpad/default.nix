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

  ags.enable = true;
  apps.foot.enable = false;
  apps.alacritty.enable = true;
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
      enable = true;
      hostname = hostname;
      barcmd = "my-shell &";
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
    direnv.enable = true;
    rofi.enable = true;
    tofi.enable = true;
    stylix.enable = true;
    stylix.hostname = hostname;
  };

  waybar.enable = true;

}
