{
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.apps.ghostty;
in
{
  options.apps.ghostty = {
    enable = mkOpt types.bool false "Enable ghostty terminal";
  };
  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        font-size = config.stylix.fonts.sizes.terminal;
        theme = "zenbones_dark";
        background-opacity = 0.95;
        window-padding-x = 2;
        window-padding-y = 2;
      };
    };
  };
}
