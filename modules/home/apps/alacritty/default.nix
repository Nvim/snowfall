{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.apps.alacritty;
in
{
  options.apps.alacritty = {
    enable = mkOpt types.bool false "Enable alacritty terminal";
  };
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        # font = {
        #   normal =  {
        #     family = "JetBrainsMono Nerd Font";
        #     style = "Bold";
        #   };
        #   size = 13;
        # };
        window = {
          # opacity = 0.88;
          blur = true;
          padding.x = 5;
          padding.y = 5;
        };
      };
    };
  };
}
