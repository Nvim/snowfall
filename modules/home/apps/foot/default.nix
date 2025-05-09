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
    server = mkOpt types.bool false "Enable server mode";
  };
  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = cfg.server;
      settings = {
        main = {
          title = "foot";
          locked-title = true;
        };
      };
    };
  };
}
