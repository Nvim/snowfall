{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.ags;
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  options.ags = {
    enable = mkOpt types.bool false "Enable AGS";
    aylur.enable = mkOpt types.bool false "Enable Aylur AGS";
    # hyprpanel.enable = mkOpt types.bool false "Enable hyprpanel";
  };
  config = mkIf cfg.enable {
    programs.ags = {
      enable = true;
      configDir = ./vanilla;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };
  };
  # if cfg.enable then
  #   {
  #     home.packages = with pkgs; [
  #       bun
  #       dart-sass
  #       fd
  #       brightnessctl
  #       inputs.matugen.packages.${system}.default
  #       slurp
  #       wf-recorder
  #       wl-clipboard
  #       wayshot
  #       swappy
  #       hyprpicker
  #       pavucontrol
  #       networkmanager
  #       gtk3
  #     ];
  #
  #     programs.ags = {
  #       enable = true;
  #       configDir = ./aylur;
  #       extraPackages = with pkgs; [ accountsservice ];
  #     };
  #   }
  # else if cfg.enable && cfg.hyprpanel.enable then
  #   { home.packages = with pkgs; [ hyprpanel ]; }
  # else
  #   { programs.ags.enable = false; };
}
