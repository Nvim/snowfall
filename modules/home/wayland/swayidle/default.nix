{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.wayland.swayidle;
in
{
  options.wayland.swayidle = {
    enable = mkOpt types.bool false "Enable swayidle";
  };
  config = mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
      ];
      timeouts = [
        {
          timeout = 240;
          command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 900;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
}
