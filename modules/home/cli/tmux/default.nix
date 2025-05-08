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
      # sensibleOnTop = true;

      extraConfig = ''
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';

      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.yank
        tmuxPlugins.vim-tmux-navigator
        {
          plugin = tmuxPlugins.prefix-highlight;
          extraConfig = ''
            set -g @prefix_highlight_show_copy_mode 'on'
            set -g status-right '#{prefix_highlight} | %a %Y-%m-%d %H:%M'
          '';
        }
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
