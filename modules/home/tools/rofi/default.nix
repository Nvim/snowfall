{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.tools.rofi;
in
{
  options.tools.rofi = {
    enable = mkOpt types.bool false "Enable rofi";
  };
  config = mkIf cfg.enable {
    home.file."${config.xdg.configHome}/rofi/config.rasi" = {
      source = ./config.rasi;
    };
    home.file."${config.xdg.configHome}/rofi/themes/theme.rasi".text = with config.lib.stylix.colors; ''
      * {
        main-bg:            #${base00};
        main-fg:            #${base05};
        main-br:            #${base0D};
        main-ex:            #${base0D};
        select-bg:          #${base0D};
        select-fg:          #${base02};
        separatorcolor:     transparent;
        border-color:       transparent;
      }
    '';
    programs.rofi = {
      package = pkgs.rofi-wayland;
      # theme = {
      #   "*" = with config.colorScheme.palette;  {
      #     main-bg = mkLiteral "#${base05}";
      #     main-fg = mkLiteral "#${base00}";
      #     main-br = mkLiteral "#${base0E}";
      #     main-ex = mkLiteral "#${base0D}";
      #     select-fg = mkLiteral "#${base0C}";
      #     select-bg = mkLiteral "#${base09}";
      #     separatorcolor = mkLiteral "#${base09}";
      #     border-color = mkLiteral "#${base09}";
      #   };
      # };

      # extraConfig = "${builtins.readFile ./config.rasi }";
      # extraConfig = ''
      # configuration {
      #   show-icons:           true;
      # }
      # '';
    };
  };
}
