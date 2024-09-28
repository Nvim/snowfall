{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.waybar;
in
{
  options.waybar = with types; {
    enable = mkOpt types.bool false "Enable waybar";
  };

  config = mkIf cfg.enable {
  home.file."${config.xdg.configHome}/waybar/style.css" = {
    source = ./css/style.css;
  };
  home.file."${config.xdg.configHome}/waybar/gruvbox.css" = {
    source = ./css/gruvbox.css;
  };
  home.file."${config.xdg.configHome}/waybar/mediaplayer.py" = {
    source = ./mediaplayer.py;
  };

  programs.waybar = {
    enable = true;
    # style = 
    #   ''
    #     ${builtins.readFile ./css/style.css}
    #   '';

    settings = {
      mainBar = {
        margin = "4px 5px -1px 5px";
        # margin = "0px 0px 0px 0px";
        layer = "top";

        modules-left =
          [ "custom/wmname" "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ ];
        modules-right = [
          "tray"
          "battery"
          "memory"
          "cpu"
          "backlight"
          "pulseaudio"
          "clock"
          "network"
          # "custom/powermenu"
        ];

        # Modules configuration
        "hyprland/workspaces" = {
          active-only = "false";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          disable-scroll = "false";
          all-outputs = "true";
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };

        "tray" = { spacing = 8; };

        "clock" = {
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format = " {:%H:%M}";
          format-alt = " {:%A, %B %d, %Y}";
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = "false";
        };

        "memory" = {
          format = " {}%";
        };

        "backlight" = {
          format = "{icon}{percent}%";
          format-icons = [ "󰃞 " "󰃟 " "󰃠 " ];
          on-scroll-up = "light -A 1";
          on-scroll-down = "light -U 1";
        };

        "battery" = {
          states = {
            warning = "20";
            critical = "10";
          };
          format = "{icon}{capacity}%";
          tooltip-format = "{timeTo} {capacity}%";
          format-charging = "󱐋{capacity}%";
          format-plugged = " ";
          format-alt = "{time} {icon}";
          format-icons = [ "  " "  " "  " "  " "  " ];
        };

        "network" = {
          format-wifi = " {essid} {signalStrength}%";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}  ";
          format-linked = "{ifname} (No IP)  ";
          format-disconnected = "󰤮 Disconnected";
          on-click = "wifi-menu";
          on-click-release = "sleep 0";
          tooltip-format = "{essid} {signalStrength}%";
        };

        "pulseaudio" = {
          format = "{icon}{volume}% {format_source}";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = "   {volume}%";
          format-source = "";
          format-source-muted = "";
          format-muted = "  {format_source}";
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [ " " " " " " ];
          };
          tooltip-format = "{desc} {volume}%";
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          on-click-middle = "pavucontrol";
          on-click-release = "sleep 0";
          on-click-middle-release = "sleep 0";
        };

        "custom/wmname" = {
          format = " ";
          on-click = "rofi -show drun";
          on-click-release = "sleep 0";
        };

        "custom/powermenu" = {
          format = " ";
          on-click = "wlogout";
          on-click-release = "sleep 1";
        };
      };
    };
  };
};
}
