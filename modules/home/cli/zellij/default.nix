{
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.cli.zellij;
in
{

  options.cli.zellij = {
    enable = mkOpt types.bool true "Enable Zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = false;
    };

    home.file."${config.xdg.configHome}/zellij/themes/custom.kdl" = {
      text =
        let
          colors = config.lib.stylix.colors.withHashtag;
        in
        ''
          themes {
            custom {
              fg "${colors.base05}"
              bg "${colors.base00}"
              black "${colors.base01}"
              red "${colors.base08}"
              // green "${colors.base0B}"
              green "${colors.base0D}"
              yellow "${colors.base0A}"
              // blue "${colors.base0D}"
              blue "${colors.base0B}"
              magenta "${colors.base0E}"
              cyan "${colors.base0C}"
              white "${colors.base07}"
              orange "${colors.base0F}"
            }
          }
        '';
    };

    home.file."${config.xdg.configHome}/zellij/config.kdl" = {
      source = ./config.kdl;
    };
  };
}

# Zellij's Gruvbox (uses OG one):
# bg "#282828"
# black "#3C3836"
# red "#CC241D"
# green "#98971A"
# yellow "#D79921"
# blue "#3C8588"
# magenta "#B16286"
# cyan "#689D6A"
# white "#FBF1C7"
# orange "#D65D0E"
