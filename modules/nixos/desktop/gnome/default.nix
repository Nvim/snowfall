{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.desktop.gnome;
in
{
  options = {
    desktop.gnome = {
      enable = mkEnableOption "enable Gnome";
    };
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
