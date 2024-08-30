{ lib, config, ... }:
with lib;
let
  cfg = config.hardware.networking;
in
{
  options = {
    enable = mkOption types.bool true "Enable networking config";
    hostname = mkOption types.str "nixos" "The hostname of the machine";
  };

  config = mkIf cfg.enable {
    networking.hostName = cfg.hostname; # Define your hostname.
    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  };
}
