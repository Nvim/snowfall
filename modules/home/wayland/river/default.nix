{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.wayland.river;
  hostname = cfg.hostname;
in
{
  options.wayland.river = {
    enable = mkOpt types.bool false "Enable river window manager";
    hostname = mkOpt types.str "desktop" "Hostname (used for monitor settings)";
    extraInit = mkOpt types.str "" "Extra config lines";
  };
  config = mkIf cfg.enable {
    services.swaync.enable = true;
    wayland.windowManager.river = {
      enable = true;
      xwayland.enable = false;
      systemd.enable = true;
      systemd.variables = [ "--all" ];
      extraSessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
        GDK_BACKEND = "wayland";
        CLUTTER_BACKEND = "wayland";
        QT_QPA_PLATFORM = "wayland";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };
      extraConfig =
        let
          colors = config.lib.stylix.colors.withHashtag;
          tileCmd =
            if hostname == "desktop" then
              ''
                filtile \
                  --output DP-3 view-padding 6 outer-padding 8 \
                  --output DP-3 smart-padding-h 320 &
                  --output HDMI-A-1 view-padding 6 outer-padding 8 \
                  --output HDMI-A-1 smart-padding-h 320 &
              ''
            else
              ''
                filtile \
                  --output eDP-1 view-padding 5 outer-padding 5 \
                  --output HDMI-A-1 view-padding 6 outer-padding 8 \
                  --output HDMI-A-1 smart-padding-h 320 &
              '';
        in
        lib.strings.concatStrings [
          ''
          #!/bin/sh
          ###############################################################################
          ### CONFIG ####################################################################
          ###############################################################################

          # Set background and border color
          # -m [ stretch | fill | fit | center | tile ]
          ${pkgs.swaybg}/bin/swaybg -i ${config.stylix.image} &
          # riverctl background-color ${colors.base05}
          # riverctl border-color-focused ${colors.base05}
          # riverctl border-color-unfocused ${colors.base0D}
          riverctl border-width 2
          riverctl focus-follows-cursor always
          riverctl set-cursor-warp on-focus-change

          # Set keyboard repeat rate
          riverctl set-repeat 50 300

          # Rules
          riverctl rule-add -app-id '*' ssd
          riverctl rule-add -title '*Mozilla Firefox' tags $((1 << 1)) 
          riverctl rule-add -title 'foot' tags $((1 << 0)) 

          riverctl rule-add -title '*- Image Viewer*' float;

          riverctl rule-add -title '*WebCord*' float;
          riverctl rule-add -title '*WebCord*' tags $((1 << 7)) ;
          riverctl rule-add -title '*WebCord*' dimensions 1600 900 ;
          riverctl rule-add -title '*WebCord*' position 50 50 ;

          riverctl rule-add -title '*Spotify*' float;
          riverctl rule-add -title '*Spotify*' tags $((1 << 7));
          riverctl rule-add -title '*Spotify*' dimensions 1600 900;
          riverctl rule-add -title '*Spotify*' position 1800 490;

          riverctl rule-add -title '*KeePassXC*' float
          riverctl rule-add -title '*KeePassXC*' tags $((1 << 8)) 
          riverctl rule-add -title '*KeePassXC*' dimensions 1600 900 

          riverctl rule-add -title '*Volume Control*' float;
          riverctl rule-add -title '*Volume Control*' dimensions 800 600;

          riverctl default-layout filtile
          ${tileCmd}

          riverctl input pointer-1267-12691-ELAN06C6:00_04F3:3193_Touchpad natural-scroll enabled
          riverctl input pointer-1267-12691-ELAN06C6:00_04F3:3193_Touchpad tap enabled
          riverctl input pointer-1267-12691-ELAN06C6:00_04F3:3193_Touchpad tap-button-map left-right-middle 
          riverctl input pointer-1267-12691-ELAN06C6:00_04F3:3193_Touchpad scroll-method two-finger
          riverctl input pointer-2-10-TPPS/2_Elan_TrackPoint pointer-accel -0.55

          ###############################################################################
          ### BINDS #####################################################################
          ###############################################################################

          riverctl keyboard-layout -options "grp:rctrl_toggle" us,fr
          ### BASICS ###
          riverctl map normal Super C close
          riverctl map normal Super+Shift Q exit
          riverctl map normal Super+Shift L spawn 'swaylock -fF'
          riverctl map normal Super E spawn 'pcmanfm'

          # Screenshot:
          riverctl map normal Super+Alt P spawn 'grim -g "$(slurp)" - | wl-copy'
          riverctl map normal Super+Shift+Alt P spawn 'grim -g "$(slurp)" ~/Pictures/screenshots/$(date +'%s.png')'

          # Notifications:
          riverctl map normal Super+Alt N spawn 'swaync-client -t -sw' 
          riverctl map normal Super+Shift+Alt N spawn 'swaync-client -d -sw' 

          # Scripts
          riverctl map normal Super Backspace spawn power-menu
          riverctl map normal Super+Alt D spawn displays

          ### PROGRAMS ###
          riverctl map normal Super Return spawn foot
          riverctl map normal Super P spawn tofi-drun 

          ### FOCUS ###
          riverctl map normal Super J focus-view next
          riverctl map normal Super K focus-view previous
          riverctl map normal Super+Alt J swap next
          riverctl map normal Super+Alt K swap previous

          ### LAYOUT CONTROL ###
          riverctl map normal Super Space zoom
          riverctl map normal Super F toggle-float
          riverctl map normal Super M send-layout-cmd filtile "monocle"
          riverctl map normal Super O send-layout-cmd filtile "smart-padding-h 640"
          riverctl map normal Super+Shift O send-layout-cmd filtile "smart-padding off"
          riverctl map normal Super T send-layout-cmd filtile "tag"
          riverctl map normal Super F11 toggle-fullscreen

          riverctl map normal Super+Alt+Control H snap left
          riverctl map normal Super+Alt+Control J snap down
          riverctl map normal Super+Alt+Control K snap up
          riverctl map normal Super+Alt+Control L snap right

          riverctl map normal Super H send-layout-cmd filtile "main-ratio -0.05"
          riverctl map normal Super L send-layout-cmd filtile "main-ratio +0.05"
          riverctl map normal Super+Alt H send-layout-cmd filtile "main-count +1"
          riverctl map normal Super+Alt L send-layout-cmd filtile "main-count -1"

          # Super+{Up,Right,Down,Left} to change layout orientation
          riverctl map normal Super Up    send-layout-cmd filtile "main-location top"
          riverctl map normal Super Right send-layout-cmd filtile "main-location right"
          riverctl map normal Super Down  send-layout-cmd filtile "main-location bottom"
          riverctl map normal Super Left  send-layout-cmd filtile "main-location left"

          # Gaps:
          riverctl map normal Super+Alt Period send-layout-cmd filtile "view-padding +1"
          riverctl map normal Super+Alt+Control Period send-layout-cmd filtile "view-padding -1"
          riverctl map normal Super+Alt Comma send-layout-cmd filtile "outer-padding +1"
          riverctl map normal Super+Alt+Control Comma send-layout-cmd filtile "outer-padding -1"

          ### OUTPUTS ###
          riverctl map normal Super Period focus-output next
          riverctl map normal Super Comma focus-output previous
          riverctl map normal Super+Shift Period send-to-output next
          riverctl map normal Super+Shift Comma send-to-output previous

          ### MOUSE ###
          riverctl map-pointer normal Super BTN_LEFT move-view
          riverctl map-pointer normal Super BTN_RIGHT resize-view
          riverctl map-pointer normal Super BTN_MIDDLE toggle-float

          ### TAGS ###
          for i in $(seq 1 9)
          do
            tags=$((1 << ($i - 1)))

            # Super+[1-9] to focus tag [0-8]
            riverctl map normal Super $i set-focused-tags $tags

            # Super+Shift+[1-9] to tag focused view with tag [0-8]
            riverctl map normal Super+Shift $i set-view-tags $tags

            # Super+Control+[1-9] to toggle focus of tag [0-8]
            riverctl map normal Super+Control $i toggle-focused-tags $tags

            # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
            riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
          done

          # Toggle latest tags:
          riverctl map normal Alt Tab focus-previous-tags

          # Focus next/prev:
          riverctl map normal Super Tab spawn 'flow cycle-tags next 9'
          riverctl map normal Super+Shift Tab spawn 'flow cycle-tags previous 9'

          # Super+0 to focus all tags
          # Super+Shift+0 to tag focused view with all tags
          all_tags=$(((1 << 32) - 1))
          riverctl map normal Super 0 set-focused-tags $all_tags
          riverctl map normal Super+Shift 0 set-view-tags $all_tags

          ### MEDIA ###
          for mode in normal locked
          do
            # Eject the optical drive (well if you still have one that is)
            riverctl map $mode None XF86Eject spawn 'eject -T'

            # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
            riverctl map $mode None XF86AudioRaiseVolume  spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+'
            riverctl map $mode None XF86AudioLowerVolume  spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-'
            riverctl map $mode None XF86AudioMute         spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'

            # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
            riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
            riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
            riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
            riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

            # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
            riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5%'
            riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
          done

          riverctl spawn i3bar-river
        ''
        cfg.extraInit
      ];
    };
  };
}
