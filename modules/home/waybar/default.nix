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
    services.swaync.enable = true;
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          # margin = "4px 5px -1px 5px";
          margin = "0px 0px 0px 0px";
          layer = "top";

          modules-left = [
            "custom/wmname"
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [ "mpris" ];
          modules-right = [
            "tray"
            "custom/notification"
            "hyprland/language"
            # "bluetooth"
            "battery"
            "memory"
            "cpu"
            "power-profiles-daemon"
            "backlight"
            "wireplumber"
            "clock"
            "network"
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

          "hyprland/window" = {
            icon = true;
          };

          "hyprland/language" = {
            format-en = " US";
            format-fr = " FR";
          };

          "mpris" = {
            format = "DEFAULT: {player_icon} {dynamic}";
            format-paused = "DEFAULT: {status_icon} <i>{dynamic}</i>";
            player-icons = {
              default = "▶";
              mpv = "🎵";
              spotify = " ";
              firefox = "󰈹 ";
            };
            status-icons = {
              paused = "⏸";
            };
          };

          "tray" = {
            spacing = 8;
          };

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
            format = " {used:0.1f}GB%";
          };

          "power-profiles-daemon" = {
            format-icons = {
              default = " ";
              performance = " ";
              balanced = " ";
              power-saver = " ";
            };
          };

          "backlight" = {
            format = "{icon}{percent}%";
            format-icons = [
              "󰃞 "
              "󰃟 "
              "󰃠 "
            ];
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
            format-icons = [
              "  "
              "  "
              "  "
              "  "
              "  "
            ];
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

          "wireplumber" = {
            format = "{icon}{volume}%";
            format-muted = " ";
            format-icons = [
              " "
              " "
              " "
            ];
            tooltip-format = "{node_name} {volume}%";
            on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
          };

          "custom/wmname" = {
            format = " ";
            # on-click = "rofi -show drun";
            on-click-release = "sleep 0";
          };

          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };
        };
      };

      style =
        with config.lib.stylix.colors.withHashtag;
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

          @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};
          * {
              font-family: "${config.stylix.fonts.monospace.name}";
              font-size: ${builtins.toString config.stylix.fonts.sizes.desktop}pt;
          }
        ''
        + (builtins.readFile ./style.css);
    };
  };
}
