{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.apps.wezterm;
in
{
  options.apps.wezterm = {
    enable = mkOpt types.bool false "Enable wezterm terminal";
  };
  config = mkIf cfg.enable {
    # programs.wezterm = {
    #   enable = true;
    # };
    home.packages = [
      pkgs.wezterm
    ];

    home.file."${config.xdg.configHome}/wezterm/wezterm.lua" = {
      # source = config.lib.file.mkOutOfStoreSymlink 
      source = ./wezterm.lua;
    };
  };
}
