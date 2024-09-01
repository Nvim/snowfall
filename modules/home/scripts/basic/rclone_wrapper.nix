{ pkgs }:
pkgs.writeShellApplication {
  name = "rclone_wrapper";

  runtimeInputs = [
    pkgs.rclone
    pkgs.diffutils
  ];

  text = ''
    STORAGE="$XDG_DATA_HOME/autobisync"
    if [ ! -d "$STORAGE" ]; then
      mkdir -p "$STORAGE"
    fi

    diff_file="$STORAGE/diff.diff"
    LOGFILE="$STORAGE/diff_checks.txt"

    if [ ! -f "$diff_file" ]; then
      touch "$diff_file"
    fi
    if [ ! -f "$LOGFILE" ]; then
      touch "$LOGFILE"
    fi

    config_file="$XDG_CONFIG_HOME/rclone/rclone.conf"
    config_backup="$XDG_CONFIG_HOME/rclone/rclone.conf.back"

    # TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    # echo "[Timestamp: $TIMESTAMP]" >>"$LOGFILE"

    run_command(){
      cp "$config_file" "$config_backup" 

      # RUN RCLONE HERE
      rclone "$@"

      if diff "$config_file" "$config_backup" > "$diff_file"; then
        echo "-No changes found, removing backup" >>"$LOGFILE"
        rm "$config_backup"
      else
        echo "-Changes found in the config file: " >>"$LOGFILE"
        cat "$diff_file" >>"$LOGFILE"
        notify-send "Auto Bisync" "Config file changed!"
      fi
    }
    #
    run_command "$@"
  '';
}
