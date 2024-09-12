{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.system.xkb;
in
{
  options.system.xkb = with types; {
    enable = mkOpt types.bool true "Set xkb layout";
    qwerty = mkEnableOption "Set qwerty layout";
  };
  config = mkIf cfg.enable {
    services.xserver = {
      xkb.layout = if cfg.qwerty then "us" else "fr";
      xkb.variant = "";
    };
  };
}
