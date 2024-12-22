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
    # services.scx.enable = if cfg.cachy.enable then true else false;
    boot.kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "nowatchdog"
    ];
    boot.consoleLogLevel = 3;
  };
}
