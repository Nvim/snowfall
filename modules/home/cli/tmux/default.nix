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

    home.packages = [
      pkgs.tmux
    ];

  };
}
