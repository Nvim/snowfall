{
  options,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.boot;
in
{
  options.system.boot = with types; {
    enable = mkOption types.bool true "Enable boot defaults";
  };

  config = mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # boot.loader.systemd-boot.configurationLimit = 8;

    # https://github.com/NixOS/nixpkgs/blob/c32c39d6f3b1fe6514598fa40ad2cf9ce22c3fb7/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix#L66
    boot.loader.systemd-boot.editor = false;
  };
}
