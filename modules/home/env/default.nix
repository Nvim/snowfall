{ lib, config, ... }:
with lib;
with lib.dotfiles;
let
  cfg = config.env;
in
{
  options.env = with types.bool; {
    enable = mkOpt types.bool true "Enable base environment variables";
  };
  config = mkIf cfg.enable {
    home.sessionPath = [
      "$HOME/.local/bin"

      # For npm -g:
      "$HOME/.npm-packages/bin"
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      MY_SCRIPTS = "$HOME/.local/bin";
      BROWSER = "firefox";
      MENU = "dmenu";
      NVIM_DIR = "$HOME/.config/newvim";
      NOTES_DIR = "$HOME/Documents/Nextcloud/Obsidian"; # Notes
      SYNC_DIR = "$HOME/Documents/Sync"; # Rest
      MANPAGER= "nvim +Man!";

      # For npm -g:
      NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
    };
  };
}
