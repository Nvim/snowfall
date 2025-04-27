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
      enable = true;

      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      focusEvents = true;
      historyLimit = 50000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-b";
      resizeAmount = 15;
      sensibleOnTop = true;

      plugins = with pkgs; [
        tmuxPlugins.yank
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.prefix-highlight
        # {
        #   plugin = tmuxPlugins.nord;
        #   extraConfig = "set -g @nord_tmux_no_patched_font '1'";
        #   # extraConfig = "set -g @nord_tmux_show_status_content '0'";
        # }
        # {
        #   plugin = tmuxPlugins.gruvbox;
        #   extraConfig = "set -g @tmux-gruvbox 'dark256'"; 
        # }
      ];
    };
  };
}
