{
  pkgs,
  lib,
  inputs,
  config,
  system,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.ags;
in
{

  options.ags = {
    enable = mkOpt types.bool false "Enable AGS";
  };
  config = mkIf cfg.enable {
    home.packages = [
      inputs.statusbar.packages.${system}.default
    ];
  };
}
