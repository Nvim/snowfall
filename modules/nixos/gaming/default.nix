{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = mkEnableOption "enable gaming packages and fixes";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gamemode
      protonup
      melonDS
      lutris
      # lime3ds DOESNT BUILD
      # heroic
      # bottles
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/naim/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
  };
}
