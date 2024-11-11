{ pkgs }:
pkgs.writeShellApplication {
  name = "kblayout";
  runtimeInputs = [ pkgs.rofi-wayland ];
  text = ''
      op1="⌨️ US"
      op2="⌨️ FR"
      options="''${op1}\n''${op2}"
      selected=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

    case "$selected" in
      "$op1")
        hyprctl keyword input:kb_layout us
        ;;
      "$op2")
        hyprctl keyword input:kb_layout fr
        ;;
      *)
        echo "Invalid option"
        ;;
      esac
  '';
}
