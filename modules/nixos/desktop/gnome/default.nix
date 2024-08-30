{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.gnome;
in
{
  options.desktop.gnome = {
    enable = mkEnableOption "Enable GNOME desktop";
  };

  config = mkIf cfg.enable {
    services.libinput.enable = true;
    # To fix GTK apps:
    programs.dconf.enable = true;

    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
