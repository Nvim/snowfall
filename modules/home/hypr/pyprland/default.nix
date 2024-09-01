# TODO: if pyprland is enabled, merge related keybinds from here
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hypr.pyprland;
in
{

  options.hypr.pyprland = with types; {
    enable = mkOpt types.bool false "Enable pyprland";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pyprland ];
    home.file."${config.xdg.configHome}/hypr/pyprland.toml" = {
      source = ./pyprland.toml;
    };
  };
}
