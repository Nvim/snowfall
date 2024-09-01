{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hypr.wlogout;
in
{
  options.hypr.wlogout = {
    enable = mkOpt types.bool false "Enable wlogout";
  };

  config = mkIf cfg.enable {
    programs.wlogout.enable = true;
    home.file."${config.xdg.configHome}/wlogout/layout" = {
      source = ./layout;
    };
    home.file."${config.xdg.configHome}/wlogout/style.css" = {
      source = ./style.css;
    };
  };
}
