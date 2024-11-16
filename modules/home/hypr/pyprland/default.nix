# TODO: if pyprland is enabled, merge related keybinds from here
{
  config,
  inputs,
  system,
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
    home.packages = [ inputs.pyprland.packages.${system}.pyprland ];
    home.file."${config.xdg.configHome}/hypr/pyprland.toml" = {
      source = ./pyprland.toml;
    };
  };
}
