{
  options,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.fonts;
in
{
  options.system.fonts = with types; {
    enable = mkOption types.bool true "Enable font settings";
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
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "UbuntuMono"
            "VictorMono"
            "IosevkaTerm"
            "CascadiaMono"
            "Ubuntu"
          ];
        })
      ];
    };
  };
}
