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
      package =
        let
          patched = pkgs.tofi.overrideAttrs (
            final: prev: {
              patches = (prev.patches or [ ]) ++ [
                ./pflag.patch
              ];
            }
          );
        in
          patched;
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
          font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
          hint-font = false;
          ascii-input = false;

          width = 280;
          height = 200;
          outline-width = 0;
          border-width = 2;
          fuzzy-match = true;
          drun-launch = true;
        };
    };
  };
}
