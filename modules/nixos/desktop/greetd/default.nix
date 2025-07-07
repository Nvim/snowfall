{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.desktop.greetd;
in
{
  options.desktop.greetd = {
    enable = mkEnableOption "enable Greetd lock screen";
  };
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session";
          user = "naim";
        };
      };
    };
  #   programs.regreet = {
  #     font = {
  #       name = "JetBrainsMono Nerd Font";
  #       package = pkgs.nerd-fonts.jetbrains-mono;
  #     };
  #     cursorTheme = {
  #       name = "Bibata-Modern-Classic";
  #       package = pkgs.bibata-cursors;
  #     };
  #     iconTheme = {
  #       name = "Papirus";
  #       package = pkgs.papirus-icon-theme;
  #     };
  #   };
  };
}
