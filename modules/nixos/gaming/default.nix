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
      lime3ds
      # heroic
      # bottles
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/naim/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
    programs.steam.enable = true;

    programs.gamescope = {
      enable = true;
      capSysNice = false;
      env = {
        "VK_DRIVER_FILES" = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
      };
      args = [
        "-f"
        "-W 3440"
        "-H 1440"
        "-r 165"
        "--force-grab-cursor"
        "--expose-wayland"
      ];
    };
    # programs.steam.gamescopeSession = {
    #   enable = true;
    # };
  };
}
