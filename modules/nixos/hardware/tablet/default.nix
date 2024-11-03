{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hardware.tablet;
in
{
  options.hardware.tablet = with types; {
    enable = mkOpt bool true "Enable OpenTablet driver";

  };
  config = mkIf cfg.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
