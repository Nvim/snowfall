{ pkgs }:
pkgs.writeShellApplication {
  name = "power-menu";
  runtimeInputs = with pkgs; [ dmenu ];
  text = ''
      op1="Lock"
      op2="Sleep"
      op3="Shutdown"
      op4="Reboot"

      options="''${op1}\n''${op2}\n''${op3}"
      selected=$(echo -e "$options" | dmenu -i -p "Choose an option")

    case "$selected" in
      "$op1")
      loginctl lock-session
        ;;
      "$op2")
        systemctl suspend
        ;;
      "$op3")
        systemctl poweroff
        ;;
      "$op4")
        reboot
        ;;
      *)
        echo "Invalid option"
        ;;
      esac
  '';
}
