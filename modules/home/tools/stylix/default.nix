{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.tools.stylix;
  hostname = cfg.hostname;
  wallp = ../../../../wallp/gruvbox/outset-island-evening.jpg;
  cursorSize = if hostname == "desktop" then 16 else 12;
  termFontSize =
    if hostname == "desktop" then
      15
    else if hostname == "hp-laptop" then
      10
    else
      12;
  appFontSize =
    if hostname == "desktop" then
      12
    else if hostname == "hp-laptop" then
      10
    else
      11;
in
{
  imports = [ inputs.stylix.homeManagerModules.stylix ];
  options.tools.stylix = {
    enable = mkOpt types.bool false "Enable stylix";
    hostname = mkOpt types.str "desktop" "Hostname (used to determine monitor settings)";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;

      opacity.terminal = 0.92;
      image = wallp;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

      fonts = {
        monospace = {
          package = pkgs.nerdfonts.override { fonts = [ "GeistMono" ]; };
          name = "GeistMono Nerd Font";
          # package = pkgs.nerdfonts.override { fonts = [ "IosevkaTerm" ]; };
          # name = "IosevkaTerm Nerd Font";
        };
        sansSerif = {
          package = pkgs.nerdfonts.override { fonts = [ "Ubuntu" ]; };
          name = "Ubuntu Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = appFontSize;
          terminal = termFontSize;
        };
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = cursorSize;
      };

      targets = {
        nixvim.enable = false;
        neovim.enable = false;
        vim.enable = true;
        waybar.enable = false;
        zellij.enable = false;
        avizo.enable = false;
        hyprland.enable = true;
        hyprlock.enable = false;
      };
    };
    #
    gtk.iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };
}
