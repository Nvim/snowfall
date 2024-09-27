{ config, lib, ... }:
with lib;
with lib.dotfiles;
let
  cfg = config.apps.zathura;
in
{
  options.apps.zathura = {
    enable = mkOpt types.bool true "Enable Zathura";
  };
  config = mkIf cfg.enable {
    home.file."${config.xdg.configHome}/zathura/zathurarc" = {
      source = ./zathura-gruvbox-dark-hard;
    };
  };
}
