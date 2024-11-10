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
    enable = mkOpt bool false "Enable OpenTablet driver";
    real = mkOpt bool true "Enable XPPen driver";

  };
  config = {
    hardware.opentabletdriver =
      if cfg.enable then
        {
          enable = true;
          daemon.enable = true;
        }
      else
        { };

    environment =
      if cfg.real then
        {
          systemPackages = [ pkgs.xp-pen-deco-01-v2-driver ];
        }
      else
        { };
  };
}
