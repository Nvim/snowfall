{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "tmux-sessions";
  runtimeInputs = with pkgs; [
    fzf
    fd
    gnused
  ];
  text = ''
    DIRS=(
        "$HOME/Code"
        "$HOME/Code/Thirdparty"
    )

    # "$HOME/Code/Thirdparty/"
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(fd . "''${DIRS[@]}" --type=dir --max-depth=1 --full-path \
            | sed "s|^$HOME/||" \
            | fzf)
        [[ $selected ]] && selected="$HOME/$selected"
    fi

    [[ ! $selected ]] && exit 0

    selected_name=$(basename "$selected" | tr . _)
    if ! tmux has-session -t "$selected_name"; then
        tmux new-session -ds "$selected_name" -c "$selected"
        tmux select-window -t "$selected_name:1"
    fi

    tmux switch-client -t "$selected_name"
  '';
}
