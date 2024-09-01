{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.apps.foot;
in
{
  options.apps.foot = {
    enable = mkOpt types.bool false "Enable foot terminal";
  };
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          title = "foot";
          locked-title = true;
        };
      };
    };
  };
}
