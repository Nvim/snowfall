{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hypr.hyprlock;
in
{
  options.hypr.hyprlock = with types; {
    enable = mkOpt types.bool true "Enable hyprlock";
  };

  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      extraConfig = ''
        background {
          monitor = 
          path = ${../../../../wallp/gruvbox/flower.jpg}
          blur_passes = 2
          contrast = 1
          brightness = 0.5
          vibrancy = 0.2
          vibrancy_darkness = 0.2
        }

        general {
          disable_loading_bar = true
          grace = 0
        }

        input-field {
          monitor = 
          size = 250, 60
          outline_thickness = 2
          dots_size = 0.2
          dots_spacing = 0.35
          dots_center = true
          outer_color = rgba(0, 0, 0, 0)
          inner_color = rgba(0, 0, 0, 0.2)
          font_color = rgba(204, 136, 34, 1)
          fade_on_empty = false
          rounding = -1
          check_color = rgb(204, 136, 34)
          placeholder_text = <i><span foreground="##cdd6f4">Input Password...</span></i>
          font_family = DepartureMono Nerd Font
          hide_input = false
          position = 0, -200
          halign = center
          valign = center
        }

        label {
          monitor =
          text = cmd[update:1000] echo "$(date +"%A, %B %d")"
          color = rgba(242, 243, 244, 0.75)
          font_size = 22
          # font_family = JetBrainsMono Nerd Font Mono
          font_family = DepartureMono Nerd Font Mono Extrabold
          position = 0, 300
          halign = center
          valign = center
        }

        # TIME
        label {
          monitor = 
          text = cmd[update:1000] echo "$(date +"%-I:%M")"
          color = rgba(242, 243, 244, 0.75)
          font_size = 95
          # font_family = JetBrainsMono Nerd Font Mono Extrabold
          font_family = DepartureMono Nerd Font Mono Extrabold
          position = 0, 200
          halign = center
          valign = center
        }
      '';
    };
  };
}
