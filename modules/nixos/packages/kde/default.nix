{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.kde;
in
{
  options.packages.kde = {
    enable = mkEnableOption "Enable KDE apps";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.qtwayland
      kdePackages.qtsvg
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kimageformats
      resvg
      ffmpegthumbs
      kdePackages.kio
      kdePackages.kio-extras
      kdePackages.kio-zeroconf
      kdePackages.kio-admin
      kdePackages.kio-extras-kf5
      kdePackages.kio-fuse
      udisks
      kdePackages.plasma-systemmonitor
      kdePackages.kate
      kdePackages.ark
      kdePackages.dolphin
      kdePackages.konsole
      kdePackages.gwenview
      kdePackages.partitionmanager
      kdePackages.kolourpaint
      kdePackages.dragon
      plasma5Packages.kdeconnect-kde
      kcalc
    ];

    programs.kdeconnect.enable = true;
    environment.sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
  };
}
