{ pkgs, config, ... }:
let
  dmenucmd = config.scripts.dmenucmd;
in
{
  hctl = pkgs.writeShellApplication {
    name = "hctl";
    text = ''
        op1="Reset"
        op2="Game mode"
        op3="Gaps"
        op4="Rounding..."
        op5="Transparency..."
        op6="Blur..."

        options="''${op1}\n''${op2}\n''${op3}\n''${op4}\n''${op5}\n''${op6}"
        selected=$(echo -e "$options" | ${dmenucmd} -p "Hyprctl:")

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
    text = ''
      op1="Inner Gaps"
      op2="Outer Gaps"
      op3="Disable all"
      op4="Restore default"
      options="''${op1}\n''${op2}\n''${op3}\n''${op4}"
      selected=$(echo -e "$options" | ${dmenucmd} -p "Gaps:")

      case "$selected" in
        "$op1")
            value=$(${dmenucmd} -p "New value:")
            hyprctl keyword general:gaps_in "$value"
        ;;
        "$op2")
            value=$(${dmenucmd} -p "New value:")
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
    text = ''
      op1="Type value"
      op2="Restore default"
      options="''${op1}\n''${op2}"
      selected=$(echo -e "$options" | ${dmenucmd} -p "Rounding:")

      case "$selected" in
        "$op1")
            value=$(${dmenucmd} -p "New value:")
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

  hctl-transparency = pkgs.writeShellApplication {
    name = "hctl-transparency";
    text = ''
      op1="Active"
      op2="Inactive"
      op3="Disable all"
      options="''${op1}\n''${op2}\n''${op3}"
      selected=$(echo -e "$options" | ${dmenucmd} -p "Opacity:")

      case "$selected" in
        "$op1")
            value=$(${dmenucmd} -p "New value:")
            hyprctl keyword decoration:active_opacity "$value"
        ;;
        "$op2")
            value=$(${dmenucmd} -p "New value:")
            hyprctl keyword decoration:inactive_opacity "$value"
        ;;
        "$op3")
            hyprctl --batch "keyword decoration:active_opacity 100; keyword decoration:inactive_opacity 100"
        ;;
        *)
          echo "Invalid option"
          ;;
        esac
    '';
  };

  hctl-blur = pkgs.writeShellApplication {
    name = "hctl-blur";
    text = ''
      op1="None"
      op2="Light"
      op3="Normal"
      op4="Strong"
      options="''${op1}\n''${op2}\n''${op3}"
      selected=$(echo -e "$options" | ${dmenucmd} -p "Blur:")

      case "$selected" in
        "$op1")
            hyprctl keyword decoration:blur:enabled 0
        ;;
        "$op2")
            hyprctl --batch "keyword decoration:blur:size 3; keyword decoration:blur:passes 1"
        ;;
        "$op3")
            hyprctl --batch "keyword decoration:blur:size 4; keyword decoration:blur:passes 2"
        ;;
        "$op4")
            hyprctl --batch "keyword decoration:blur:size 5; keyword decoration:blur:passes 3"
        ;;
        *)
          echo "Invalid option"
          ;;
        esac
    '';
  };
}
