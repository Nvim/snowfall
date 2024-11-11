{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.proton;
in
{
  options.packages.proton = {
    enable = mkEnableOption "Enable Proton packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [

      proton-pass
      protonvpn-gui
      protonmail-desktop
    ];
  };
}
