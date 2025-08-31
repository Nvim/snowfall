{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.bitwarden;
in
{
  options.packages.bitwarden = {
    enable = mkEnableOption "Enable Bitwarden packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitwarden-cli
      bitwarden-desktop
      bitwarden-menu
    ];
  };
}
