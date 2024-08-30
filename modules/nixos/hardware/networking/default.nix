{ lib, config, ... }:
with lib;
with lib.dotfiles;
let
  cfg = config.hardware.networking;
in
{
  options.hardware.networking = with types; {
    enable = mkOpt types.bool true "Enable networking config";
    hostname = mkOpt types.str "nixos" "The hostname of the machine";
  };

  config = mkIf cfg.enable {
    networking.hostName = cfg.hostname; # Define your hostname.
    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  };
}
