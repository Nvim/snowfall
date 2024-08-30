{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.system.kernel;
in
{

  options.system.kernel = {
    enable = mkOpt types.bool true "Enable Zen kernel";
  };
  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.kernelParams = [ "quiet" ];
  };
}
