{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.tools.mpd;
in
{
  options.tools.mpd = {
    enable = mkOpt types.bool false "Enable mdp";
  };
  config = mkIf cfg.enable {
    services.mpd-mpris.enable = true;
    services.mpd-mpris.mpd.useLocal = true;

    services.mpd = {
      enable = true;
      musicDirectory = "$HOME/Music";
    };
  };
}
