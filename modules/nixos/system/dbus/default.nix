{ config, lib, ... }:
with lib;
let
  cfg = config.system.dbus;
in
{

  options.system.dbus = {
    enable = mkEnableOption "Enable dbus";
  };
  config = mkIf cfg.enable { services.dbus.enable = true; };
}
