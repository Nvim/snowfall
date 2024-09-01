{ pkgs }:
{
  bookmarks = pkgs.writeShellApplication {
    name = "bookmarks";
    runtimeInputs = with pkgs; [ rofi-wayland ];
    text = ''
        youtube="Youtube"
        chatgpt="ChatGPT"
        github="GitHub"
        
        options="''${youtube}\n''${chatgpt}\n''${github}"
        choice=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

      case "$choice" in
        "$youtube")
          $BROWSER https://youtube.com
          ;;
        "$chatgpt")
          $BROWSER https://chat.openai.com
          ;;
        "$github")
          $BROWSER https://github.com/Nvim
          ;;
        *)
          echo "Invalid option"
          ;;
        esac
    '';
  };
}
