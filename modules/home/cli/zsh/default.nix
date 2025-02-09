{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
with lib;
let
  cfg = config.cli.zsh;
in
{
  options.cli.zsh = {
    enable = mkEnableOption "zsh config";
  };

  config = mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        update_check = false;
        style = "compact";
      };
    };
    programs.starship = {
      enable = true;
      settings = {
        username = {
          show_always = true;
          style_user = "bold yellow";
          style_root = "bold red";
          format = "[$user]($style)";
        };
        hostname = {
          ssh_only = false;
          style = "bold blue";
          format = "[$hostname]($style)";
        };
        nix_shell = {
          style = "bold blue";
          symbol = "❄️ ";
          format = "[$symbol]($style)";
        };
        character = {
          success_symbol = "[ 󰜴](bold cyan)";
          error_symbol = "[ 󰜴](bold red)";
        };
        directory = {
          style = "bold green";
        };
        git_branch = {
          format = "[$symbol$branch]($style)";
          truncation_length = 8;
          ignore_branches = [ ];
        };
        format = ''[\[](bold red)$username[@](bold gray dimmed)$hostname $directory$nix_shell$git_branch$direnv$container[\]](bold red)$character'';
        #\[$username$directory \[$git_branch $git_status\]
      };
    };
    programs.zsh =
      let
        myAliases = {
          # ls = "ls -hN --color=auto --group-directories-first";
          ls = "eza --icons=always --color-scale=all --color=always --group-directories-first --color-scale-mode=gradient";
          rf = "rm -rf";
          # cat = "bat";

          df = "cd ~/.dotfiles";
          dw = "cd ~/Downloads";
          dc = "cd ~/Documents";
          oo = "cd $NOTES_DIR";

          nv = "nvim";
          nnv = "~/.config/nvim/result/bin/nvim";
          z = "zellij";
          lg = "lazygit";

          gst = "git status";
          gadd = "git add .";
          gcm = "git commit -m ";
          glog = "git log --oneline --graph --decorate";
          gps = "git push";
          gpl = "git pull";
          gplr = "git pull --rebase";
        };
      in
      {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = myAliases;
        historySubstringSearch.enable = true;
        defaultKeymap = "emacs";
        history = {
          size = 100000;
          path = "${config.xdg.dataHome}/zsh/history";
          extended = true;
          ignoreAllDups = true;
          share = true;
          ignoreSpace = true; # don't save in hist if cmd starts with space
        };
        # This runs after compinit. Plugins recommends loading it now
        completionInit = ''
          source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        '';
        plugins = [ ];
        initExtra = ''
          bindkey '^n' history-search-forward 
          bindkey '^p' history-search-backward 
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix 
          zstyle ':completion:*' menu no
          # preview directory's content with eza when completing cd
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
          eval "$(fzf --zsh)"
          eval "$(direnv hook zsh)"
          if [ -n "''${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
          fi

          atuin-setup() {
            if ! which atuin &> /dev/null; then return 1; fi
            bindkey '^E' _atuin_search_widget

            export ATUIN_NOBIND="true"
            fzf-atuin-history-widget() {
              local selected num
              setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

              local atuin_opts="--cmd-only --limit ''${ATUIN_LIMIT:-5000}"
              local fzf_opts=(
                --height=''${FZF_TMUX_HEIGHT:-50%}
                --tac
                "-n2..,.."
                --tiebreak=index
                "--query=''${LBUFFER}"
                "+m"
                "--bind=ctrl-d:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
              )

              selected=$(
                eval "atuin search ''${atuin_opts}" |
                    fzf "''${fzf_opts[@]}"
              )
              local ret=$?
              if [ -n "$selected" ]; then
                # the += lets it insert at current pos instead of replacing
                LBUFFER+="''${selected}"
              fi
              zle reset-prompt
              return $ret
            }
            zle -N fzf-atuin-history-widget
            bindkey '^R' fzf-atuin-history-widget
          }
          atuin-setup
        '';
      };
    home.packages = with pkgs; [ fzf ];
  };
}
