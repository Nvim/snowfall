{ pkgs }:
let 
  wrapper = import ./rclone_wrapper.nix { inherit pkgs; };
in
pkgs.writeShellApplication {
  name = "autobisync";

  runtimeInputs = [
    pkgs.rclone
    pkgs.findutils
    wrapper
  ];

  text = ''
    run_bisync() {
      remote_name=$1
      local_path=$2
      flags=$3

      mkdir -p "$local_path"
      echo "- RUNNING COMMAND: ''${RCLONE_CMD} bisync ''${remote_name}: ''${local_path} ''${flags}" >> "$LOGFILE"

      if ! $RCLONE_CMD bisync "''${remote_name}:" "$local_path" "$flags" "--conflict-resolve" "newer" 2>> "$LOGFILE"; then
        notify-send "Auto Bisync" "Error syncing remote $remote_name! Check Logs for info." -u critical -t 3600000
      else
        notify-send "Auto Bisync" "Remote $remote_name synced" -u low -t 1500
      fi

    }

    if command -v ${wrapper}/bin/rclone_wrapper &> /dev/null; then
      RCLONE_CMD="${wrapper}/bin/rclone_wrapper"
    else
      RCLONE_CMD="rclone"
    fi

    TIMESTAMP=$(date +"%Y-%m-%d_%H:%M:%S")

    STORAGE="$XDG_DATA_HOME/autobisync"
    if [ ! -d "$STORAGE" ]; then
      mkdir -p "$STORAGE"
    fi
    if [ ! -d "$STORAGE/logs" ]; then
      mkdir -p "$STORAGE/logs"
    fi

    LOGFILE="$STORAGE/logs/''${TIMESTAMP}_log.txt" # .local/share
    if [ ! -f "$LOGFILE" ]; then
      touch "$LOGFILE"
    fi

    # remotes=("Keepass" "Notes" "Perso" "Feeds" "Obsidian")
    remotes=("$@")
    base_path="$HOME/Documents/Sync"
    cache_path="$XDG_CACHE_HOME/rclone/bisync" # .cache/

    # Home path with underscores instead of slashes
    # home_underscores=$(echo "$HOME" | sed 's/\//_/g' | sed 's/^_//')
    base_path_underscores=$(echo "$base_path" | sed 's/\//_/g' | sed 's/^_//')

    cached_remotes=()
    other_remotes=()

    #########
    # BEGIN #
    #########

    # sshellcheck source=/home/naim/.nix-profile/etc/profile.d/hm-session-vars.sh
    # sshellcheck disable=SC1091
    # source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh";
    cd "$HOME/Documents/Sync"
    echo "[Timestamp: $TIMESTAMP]" >> "$LOGFILE"
    notify-send "Auto Bisync" "Syncing remotes..."

    # Find wether a remote should be run with --resync flag:
    for dir in "''${remotes[@]}"; do
      if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
      fi
      # Local to remote / Remote to local:
      pattern1="''${cache_path}/''${base_path_underscores}_''${dir}..''${dir}_.*"
      pattern2="''${cache_path}/''${dir}_..''${base_path_underscores}_''${dir}.*"

      echo "* Remote: ''${dir} *" >> "$LOGFILE"

      if find "$cache_path" -type f -name "$(basename "$pattern1")" | grep -q . || find "$cache_path" -type f -name "$(basename "$pattern2")" | grep -q .; then
        echo "-Cache for bisync between ''${dir} and ''${base_path} found" >> "$LOGFILE"
        cached_remotes+=("$dir")
      else
        echo "-Cache for bisync between ''${dir} and ''${base_path} not found" >> "$LOGFILE"
        other_remotes+=("$dir")
      fi
    done

    # Run rsync without --resync:
    for remote in "''${cached_remotes[@]}"; do
      local_path="''${base_path}/''${remote}"
      run_bisync "$remote" "$local_path" "--verbose"
    done

    for remote in "''${other_remotes[@]}"; do
      local_path="''${base_path}/''${remote}"
      run_bisync "$remote" "$local_path" "--resync"
    done


  '';
}
