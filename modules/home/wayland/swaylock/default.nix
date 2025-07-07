{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.wayland.swaylock;
in
{
  options.wayland.swaylock = {
    enable = mkOpt types.bool false "Enable swaylock";
  };
  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      # settings = "";
    };
  };
}
