{ pkgs }:
pkgs.writeShellApplication {
  name = "newnote";

  text = ''
    if [ -z "$1" ]; then
      echo "Error: provide a filename"
    exit 1
    fi

    file_name=$(echo "$1" | tr ' ' '-')
    formatted_name=$(date "+%Y-%m-%d")_''${file_name}.md
    cd "$NOTES_DIR" || exit
    touch "inbox/''${formatted_name}"
    nvim "inbox/''${formatted_name}"
  '';
}
