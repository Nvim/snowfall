{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.cli.yazi;
  plugins-repo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash = "sha256-jg8+GDsHOSIh8QPYxCvMde1c1D9M78El0PljSerkLQc=";
  };
in
{
  options.cli.yazi = {
    enable = mkOpt types.bool false "Enable Yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";

      settings = {
        manager = {
          show_hidden = true;
        };
        preview = {
          max_width = 1000;
          max_height = 1000;
        };
        sort_by = "modified";
        sort_dir_first = true;
        scrolloff = 3;
      };

      plugins = {
        # chmod = "${plugins-repo}/chmod.yazi";
        # full-border = "${plugins-repo}/full-border.yazi";
        # max-preview = "${plugins-repo}/max-preview.yazi";
        # starship = pkgs.fetchFromGitHub {
        #   owner = "Rolv-Apneseth";
        #   repo = "starship.yazi";
        #   rev = "main";
        #   sha256 = "sha256-OL4kSDa1BuPPg9N8QuMtl+MV/S24qk5R1PbO0jgq2rA=";
        # };
      };

      initLua = ''
        -- require("full-border"):setup()
        -- require("starship"):setup()
      '';

      keymap = {
        manager.prepend_keymap = [
          # {
          #   on = [ "T" ];
          #   run = "plugin --sync max-preview";
          #   desc = "Maximize or restore the preview pane";
          # }
          # {
          #   on = [
          #     "c"
          #     "m"
          #   ];
          #   run = "plugin chmod";
          #   desc = "Chmod on selected files";
          # }
        ];
      };
    };
  };
}
