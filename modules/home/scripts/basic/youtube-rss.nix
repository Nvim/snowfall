{ pkgs }:
pkgs.writeShellApplication {
  name = "youtube-rss";
  runtimeInputs = [ pkgs.curl ];

  text = ''
    BASEURL="https://www.youtube.com/feeds/videos.xml?channel_id="

      [ -z "$1" ] && printf "Usage: %s [options] - u [URL | Username]\n" "$0" && exit 1

      URL=$1
      curl -Ls "$URL" >/dev/null || URL="https://www.youtube.com/$URL"

      # Actually getting the ID
      read -r ID < <(curl -Ls "$URL" | grep -o -P '.{0,0}channel_id.{0,25}' | sed '$!d' | cut -c 12-35)
      [ -z "$ID" ] && printf "Channel not found.\n" && exit 1

      # Print out the credentials
      printf "ID:\t%s\n" "$ID"
      printf "RSS:\t%s\n" "$BASEURL""$ID"

  '';
}
