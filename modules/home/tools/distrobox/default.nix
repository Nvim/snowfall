{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let 
  cfg = config.tools.distrobox;
in
{
  options.tools.distrobox = {
    enable = mkOpt types.bool false "Enable distrobox";
  };
  config = mkIf cfg.enable {
    programs.distrobox = {
      enable = true;
      enableSystemdUnit = false; 
    };
  };
}
