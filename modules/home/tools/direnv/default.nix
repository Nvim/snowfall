{ config, lib, ... }:
with lib;
with lib.dotfiles;
let
  cfg = config.tools.direnv;
in
{
  options.tools.direnv = {
    enable = mkOpt types.bool true "Enable direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
      silent = true;
    };
  };
}
