{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.xkb;
in
{
  options.system.xkb = {
    enable = mkOption types.bool true "Set xkb layout";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      xkb.layout = "fr";
      xkb.variant = "";
    };
  };
}
