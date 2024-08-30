{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.hardware.bluetooth;
in
{
  options.hardware.bluetooth = {
    enable = mkOption types.bool true "Enable bluetooth settings";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
    services.blueman.enable = true;
  };
}
