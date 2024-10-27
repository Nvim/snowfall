{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.system.kernel;
in
{
  imports = [ inputs.chaotic.nixosModules.default ];
  options.system.kernel = {
    zen.enable = mkOpt types.bool false "Enable Zen kernel";
    cachy.enable = mkOpt types.bool false "Enable Cachy kernel";
  };
  config = {
    chaotic.nyx.overlay.enable = true;
    boot.kernelPackages =
      if cfg.zen.enable then
        pkgs.linuxPackages_zen
      else if cfg.cachy.enable then
        pkgs.linuxPackages_cachyos
      else
        pkgs.linuxPackages;
    boot.kernelParams = [ "quiet" ];
  };
}
