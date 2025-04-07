{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.cli.tmux;
in
{

  options.cli.tmux = {
    enable = mkOpt types.bool true "Enable tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = false;
    };

    home.file."${config.xdg.configHome}/tmux/tmux.conf" = {
      source = ./tmux.conf;
    };

    home.file.".tmux/plugins/tpm" =
      let
        tpmRepo = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tpm";
          rev = "master";
          hash = "sha256-hW8mfwB8F9ZkTQ72WQp/1fy8KL1IIYMZBtZYIwZdMQc=";
        };
      in
      {
        source = config.lib.file.mkOutOfStoreSymlink tpmRepo;
        recursive = true;
      };

    home.packages = [
      pkgs.tmux
    ];

  };
}
