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
        initExtra = ''
          bindkey '^n' history-search-forward 
          bindkey '^p' history-search-backward 
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          eval "$(fzf --zsh)"
          eval "$(direnv hook zsh)"
          if [ -n "''${commands[fzf-share]}" ]; then
          source "$(fzf-share)/key-bindings.zsh"
          source "$(fzf-share)/completion.zsh"
          fi
        '';

        history = {
          size = 100000;
          path = "${config.xdg.dataHome}/zsh/history";
          extended = true;
          ignoreAllDups = true;
          share = true;
          ignoreSpace = true; # don't save in hist if cmd starts with space
        };
        plugins = [
          {
            # will source zsh-autosuggestions.plugin.zsh
            name = "zsh-autosuggestions";
            src = pkgs.fetchFromGitHub {
              owner = "zsh-users";
              repo = "zsh-autosuggestions";
              rev = "v0.4.0";
              sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
            };
          }
        ];
      };
    home.packages = with pkgs; [ fzf ];
  };
}
