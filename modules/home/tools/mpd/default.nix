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
    home.packages = with pkgs; [ mpc playerctl ];
    services.mpd-mpris.enable = true;
    services.mpd-mpris.mpd.useLocal = true;

    services.mpd = {
      enable = true;
      musicDirectory = "${config.home.homeDirectory}/Documents/Nextcloud/Music";
      network.startWhenNeeded = true;
      extraConfig = ''
                audio_output {
                type            "pipewire"
                name            "PipeWire Sound Server"
        }
      '';
    };
  };
}
