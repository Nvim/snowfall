{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.theming.qt;
in
{
  options.theming.qt = with types.bool; {
    enable = mkOpt types.bool true "Enable QT theming";
  };
  config = mkIf cfg.enable {
    qt.enable = true;
    # qt.style.package = pkgs.adwaita-qt;
    qt.style.name = "Kvantum";
    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
    home.packages = [
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.libsForQt5.oxygen-icons
    ];
  };
}
