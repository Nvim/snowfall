{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hypr.hyprland;
  hostname = cfg.hostname;
in
{
  options.hypr.hyprland = {
    enable = mkOpt types.bool false "Enable Hyprland DE";
    hostname = mkOpt types.str "desktop" "Hostname (used to determine monitor settings)";
  };

  config = mkIf cfg.enable {
    # source normal config:
    home.file."${config.xdg.configHome}/hypr/binds.conf" = {
      source = ./binds/binds.conf;
    };
    home.file."${config.xdg.configHome}/hypr/animations/animations3.conf" = {
      source = ./animations/animations3.conf;
    };

    # enable hyprland
    wayland.windowManager.hyprland = {
      # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      enable = true;
      systemd.enable = true;
      systemd.variables = [ "--all" ];
      xwayland.enable = true;

      settings =
        let
          border = if hostname == "desktop" then "2" else "3";
          outerGaps = if hostname == "desktop" then "10" else "6";
          innerGaps = if hostname == "desktop" then "5" else "3";
          rounding = if hostname == "desktop" then "8" else "4";
          maxFloatW = if hostname == "desktop" then "2560" else "1280";
          maxFloatH = if hostname == "desktop" then "1390" else "720";
        in
        {
          "$terminal" = "foot";
          "$fileManager" = "nautilus";
          "$menu" = "rofi -show drun";
          "$windows" = "rofi -show window";

          exec-once =
            let
              agsCmd = "hyprpanel &";
            in
            # if config.ags.enable && config.ags.aylur.enable then
            #   "ags &"
            # else if config.ags.enable && config.ags.hyprpanel.enable then
            #   "hyprpanel &"
            # else
            #   "";
            [
              # "swww-daemon &"
              agsCmd
              "hyprshade on vibrance"
              "pypr"
            ];

          source = [
            "/home/naim/.config/hypr/binds.conf"
            "/home/naim/.config/hypr/animations/animations3.conf"
          ];

          monitor = [
            "DP-1,3440x1440@165,0x0,auto,bitdepth,10,vrr,1"
            # "eDP-1,1366x768@60,auto,1"
            "eDP-1,1920x1200@60,auto,1"
          ];
          xwayland = {
            force_zero_scaling = "true";
          };
          input = {
            kb_layout = "us";
            follow_mouse = "1";
            sensitivity = "-0.2";
            touchpad = {
              natural_scroll = "true";
            };
          };

          # general = with config.stylix.base16Scheme; {
          general = {
            gaps_in = "${innerGaps}";
            gaps_out = "${outerGaps}";
            border_size = "${border}";
            layout = "master";

            # "col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0D})";
            # "col.inactive_border" = lib.mkForce "rgba(${config.stylix.base16Scheme.base03}aa)";
            # "col.active_border" = lib.mkForce "rgba(ffffffff)";

            allow_tearing = "false";
          };

          decoration = {
            rounding = "${rounding}";

            blur = {
              xray = "true";
              enabled = "true";
              size = "4";
              passes = "2";
              new_optimizations = "true";
              ignore_opacity = "true";
            };
            drop_shadow = "no";
            shadow_range = "6";
            shadow_render_power = "3";
            "col.shadow" = lib.mkForce "rgba(1a1a1aee)";
          };

          master = {
            always_center_master = "true";
            mfact = 0.6;
            new_on_top = true;
          };

          misc = {
            force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
            enable_swallow = true;
            swallow_regex = "Alacritty";
            animate_mouse_windowdragging = true;
          };

          windowrulev2 = [
            "suppressevent maximize, class:.*"
            "float, class:^(waypaper)$"
            "float, title:^(Sandbox)$"
            "maxsize ${maxFloatW} ${maxFloatH}, class:.*,floating:1"
            "stayfocused, class:(Rofi)"
          ];
        };
    };
  };
}