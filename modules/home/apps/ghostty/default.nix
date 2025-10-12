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
      enableZshIntegration = false;
      settings = {
        background-opacity = 0.96;
        window-decoration = false;
        adjust-cell-height = "15%";
        # theme = "Zenbones Dark";
        # window-padding-x = 2;
        # window-padding-y = 2;
      };
    };
  };
}
