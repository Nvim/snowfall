{ lib, config, ... }:
with lib;
let
  cfg = config.system.kernel;
in
{

  options.system.kernel = {
    enable = mkOption types.bool true "Enable Zen kernel";
  };
  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.kernelParams = [ "quiet" ];
  };
}
