{ pkgs }:
{
  power-menu = pkgs.writeShellApplication {
    name = "power-menu";
    runtimeInputs = with pkgs; [ rofi-wayland ];
    text = ''
        op1="Sleep"
        op2="Shutdown"
        op3="Reboot"

        options="''${op1}\n''${op2}\n''${op3}"
        selected=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

      case "$selected" in
        "$op1")
          systemctl suspend
          ;;
        "$op2")
          systemctl poweroff
          ;;
        "$op3")
          reboot
          ;;
        *)
          echo "Invalid option"
          ;;
        esac
    '';
  };
}
