{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.misc;
in
{
  options.packages.misc = {
    enable = mkOpt types.bool true "Enable misc packages";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      transmission_4
      feather
      obs-studio
    ];
  };
}
