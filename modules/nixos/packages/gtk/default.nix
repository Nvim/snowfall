{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.gtk;
in
{
  options.packages.gtk = {
    enable = mkEnableOption "Enable GTK apps";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nautilus
      gnome-disk-utility
      gnome-calculator
      totem
      gnome-usage
      xfce.ristretto
      xfce.tumbler
    ];
  };
}
