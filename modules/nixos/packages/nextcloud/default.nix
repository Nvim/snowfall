{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.nextcloud;
in
{
  options.packages.nextcloud = {
    enable = mkEnableOption "Enable Nextcloud packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nextcloud-client
    ];
  };
}
