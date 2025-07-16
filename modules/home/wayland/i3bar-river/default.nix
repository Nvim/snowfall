{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.wayland.i3bar-river;
in
{
  options.wayland.i3bar-river = {
    enable = mkOpt types.bool false "Enable i3bar-river";
  };
  config = mkIf cfg.enable {
    programs.i3bar-river = {
      enable = true;
      settings =
      let
        colors = config.lib.stylix.colors.withHashtag;
        font = config.stylix.fonts.monospace.name;
      in
      {
        command = "i3status-rs";
        background = "${colors.base00}";
        color = "${colors.base04}";
        separator = "${colors.base03}";
        tag_fg = "${colors.base06}";
        tag_bg = "${colors.base00}";
        tag_focused_fg = "${colors.base05}";
        tag_inactive_fg = "${colors.base05}";
        tag_urgent_fg = "${colors.base05}";
        tag_focused_bg = "${colors.base0D}";
        tag_inactive_bg = "${colors.base00}";
        tag_urgent_bg = "${colors.base08}";
        font = "${font} 10";
        height = 20;
        margin_top = 0;
        margin_bottom = 0;
        margin_left = 0;
        margin_right = 0;
        separator_width = 1.0;
        tags_r = 0.0;
        tags_padding = 9.0;
        tags_margin = 0.0;
        blocks_r = 0.0;
        blocks_overlap = 0.0;
        position = "bottom";
        layer = "top";
        hide_inactive_tags = true;
        invert_touchpad_scrolling = true;
        show_tags = true;
        show_layout_name = false;
        blend = true;
        show_mode = true;
        wm.river = {
          max_tag = 9;
        };
        # Per output overrides;
        # [output.your-output-name];
        # right now only "enable" option is available;
        # enable = false;
        #;
        # You can have any number of overrides;
        # [output.eDP-1];
        # enable = false;
      };
    };
  };
}
