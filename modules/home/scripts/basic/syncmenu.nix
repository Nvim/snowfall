{ pkgs }:
pkgs.writeShellApplication {
  name = "syncmenu";
  runtimeInputs = with pkgs; [
    rofi-wayland
    dmenu
  ];
  text = ''
      Obsidian="🧠 Obsidian"
      Perso="🗂️ Perso"
      Keepass="🔒 Keepass"
      Feeds="🌐 Feeds"
      ING1="📝 ING"
      
      options="''${Obsidian}\n''${Perso}\n''${Keepass}\n''${Feeds}\n''${ING1}"
      choice=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

    case "$choice" in
      "$Obsidian")
        autobisync Obsidian
        ;;
      "$Perso")
        autobisync Perso
        ;;
      "$Keepass")
        autobisync Keepass
        ;;
      "$Feeds")
        autobisync Feeds
        ;;
      "$ING1")
        autobisync ING
        ;;
      *)
        echo "Invalid option"
        ;;
      esac
  '';
}
