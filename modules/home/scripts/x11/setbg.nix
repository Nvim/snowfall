{ pkgs }:
pkgs.writeShellScriptBin "setbg" ''
  bgloc="''${XDG_DATA_HOME}/bg"

  # Give -s as parameter to make notifications silent.
  # while getopts "s" o; do case "$o" in
  #   s) silent='1' ;;
  # esac done

  # shift $((OPTIND - 1))

  trueloc="$(readlink -f "$1")" &&
  echo $trueloc
  case "$(${pkgs.file}/bin/file --mime-type -b "$trueloc")" in
    # image/* ) ln -sf "$trueloc" "$bgloc" && [ -z "$silent" ] && notify-send -i "$bgloc" "Changing wallpaper..." ;;
    image/* ) ln -sf "$trueloc" "$bgloc" && [ -z "$silent" ] ;;
    # inode/directory ) ln -sf "$(find "$trueloc" -iregex '.*.\(jpg\|jpeg\|png\|gif\)' -type f | shuf -n 1)" "$bgloc" && [ -z "$silent" ] && notify-send -i "$bgloc" "Random Wallpaper chosen." ;;
    inode/directory ) ln -sf "$(find "$trueloc" -iregex '.*.\(jpg\|jpeg\|png\|gif\)' -type f | shuf -n 1)" "$bgloc" && [ -z "$silent" ] ;;
    *) [ -z "$silent" ]; exit 1;;
  esac

  ${pkgs.xwallpaper}/bin/xwallpaper --zoom "$bgloc"
''
