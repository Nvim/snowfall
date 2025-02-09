{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.system.fonts;
in
{
  options.system.fonts = with types; {
    enable = mkOpt types.bool true "Enable font settings";
  };

  config = mkIf cfg.enable {

    fonts = {
      fontconfig = {
        enable = true;

        hinting = {
          enable = true;
          style = "full";
        };

        subpixel = {
          lcdfilter = "default";
          rgba = "rgb";
        };

        antialias = true;
      };

      #

      packages = with pkgs; [
        material-symbols
        material-icons
        nerd-fonts.ubuntu
        nerd-fonts.ubuntu-mono
        nerd-fonts.jetbrains-mono
        nerd-fonts.victor-mono
        nerd-fonts.iosevka-term
        nerd-fonts.caskaydia-mono
        nerd-fonts.departure-mono
        nerd-fonts.bigblue-terminal
      ];
    };
  };
}
