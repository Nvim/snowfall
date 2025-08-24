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
  colors = config.lib.stylix.colors.withHashtag;
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

      extraConfig = ''
        # == KEYS == #
        bind r source-file ~/.config/tmux/tmux.conf
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind C new-window -c "#{pane_current_path}" # window in pane's path
        bind G neww -n "lazygit" lazygit
        bind M-c attach-session -c "#{pane_current_path}" # change session dir to current pane's

        # == RICING == #
        set -g status-justify absolute-centre
        # set -g status-style "bg=default"
        # set -g window-status-current-style "fg=${colors.base0D} bg=default bold"
      '';

      plugins = with pkgs; [
        # tmuxPlugins.sensible
        tmuxPlugins.yank
        tmuxPlugins.vim-tmux-navigator
        {
          plugin = tmuxPlugins.prefix-highlight;
          extraConfig = ''
            set -g @prefix_highlight_show_copy_mode 'on'
            set -g status-right '#{prefix_highlight}'
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
