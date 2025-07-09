{ pkgs, config, ...}:
let
  dmenucmd = config.scripts.dmenucmd;
in
{
  power-menu = pkgs.writeShellApplication {
    name = "power-menu";
    text = ''
        op1="Sleep"
        op2="Shutdown"
        op3="Reboot"

        options="''${op1}\n''${op2}\n''${op3}"
        selected=$(echo -e "$options" | ${dmenucmd} -p "Choose an option")

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
