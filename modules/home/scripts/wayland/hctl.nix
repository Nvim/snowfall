{ pkgs, ... }:
{
  hctl = pkgs.writeShellApplication {
    name = "hctl";
    runtimeInputs = [ pkgs.rofi-wayland ];
    text = ''
        op1="Reset"
        op2="Game mode"
        op3="Gaps"
        op4="Rounding..."
        op5="Transparency..."
        op6="Blur..."

        options="''${op1}\n''${op2}\n''${op3}\n''${op4}\n''${op5}\n''${op6}"
        selected=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

      case "$selected" in
        "$op1")
          hyprctl reload
          ;;
        "$op2")
          hyprctl --batch "keyword general:gaps_out 0; keyword general:gaps_in 0; keyword decoration:rounding 0"
          hyprctl --batch "keyword decoration:blur:enabled 0; keyword decoration:drop_shadow 0"
          hyprctl keyword animations:enabled 0
          ;;
        "$op3")
          hctl-gaps
          ;;
        "$op4")
          hctl-rounding
          ;;
        "$op5")
          hctl-transparency
          ;;
        "$op6")
          hctl-blur
          ;;
        *)
          echo "Invalid option"
          ;;
        esac
    '';
  };

  hctl-gaps = pkgs.writeShellApplication {
    name = "hctl-gaps";
    runtimeInputs = [ pkgs.rofi-wayland ];
    text = ''
      op1="Inner Gaps"
      op2="Outer Gaps"
      op3="Disable all"
      op4="Restore default"
      options="''${op1}\n''${op2}\n''${op3}\n''${op4}"
      selected=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

      case "$selected" in
        "$op1")
            value=$(rofi -dmenu -p "Enter new value")
            hyprctl keyword general:gaps_in "$value"
        ;;
        "$op2")
            value=$(rofi -dmenu -p "Enter new value")
            hyprctl keyword general:gaps_out "$value"
        ;;
        "$op3")
          hyprctl --batch "keyword general:gaps_in 0; keyword general:gaps_out 0"
        ;;
        "$op4")
          hyprctl --batch "keyword general:gaps_in 5; keyword general:gaps_out 10"
        ;;
        *)
          echo "Invalid option"
          ;;
        esac
    '';
  };

  hctl-rounding = pkgs.writeShellApplication {
    name = "hctl-rounding";
    runtimeInputs = [ pkgs.rofi-wayland ];
    text = ''
      op1="Type value"
      op2="Restore default"
      options="''${op1}\n''${op2}"
      selected=$(echo -e "$options" | rofi -dmenu -p "Choose an option")

      case "$selected" in
        "$op1")
            value=$(rofi -dmenu -p "Enter new value")
            hyprctl keyword decoration:rounding "$value"
        ;;
        "$op2")
            hyprctl keyword decoration:rounding 10
        ;;
        *)
          echo "Invalid option"
          ;;
        esac
    '';
  };
}
