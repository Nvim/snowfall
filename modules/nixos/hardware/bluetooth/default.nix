{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hardware.bluetoothSettings;
in
{
  options.hardware.bluetoothSettings = with types; {
    enable = mkOpt types.bool true "Enable bluetooth settings";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
    services.blueman.enable = true;
  };
}
