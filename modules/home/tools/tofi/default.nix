{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.tools.tofi;
in
{
  options.tools.tofi = {
    enable = mkOpt types.bool false "Enable tofi";
  };
  config = mkIf cfg.enable {
    programs.tofi = {
      enable = true;
      settings =
        let
          colors = config.lib.stylix.colors.withHashtag;
        in
        {
          background-color = "${colors.base00}";
          border-color = "${colors.base0D}";
          text-color = "${colors.base05}";
          selection-color = "${colors.base0D}";
          font-size = 13;
          # font = "/nix/store/97bd4ldnygwq8vp7hh713dj30lir5h5s-home-manager-path/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
          font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
          hint-font = false;
          ascii-input = false;

          width = 280;
          height = 300;
          outline-width = 0;
          border-width = 2;
          fuzzy-match = true;
          drun-launch = true;
        };
    };
  };
}
