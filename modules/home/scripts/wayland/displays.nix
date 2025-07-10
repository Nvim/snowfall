{ pkgs, config, ...}:
let
  dmenucmd = config.scripts.dmenucmd;
  defaultDisplay = config.scripts.defaultDisplay;
in
{
  displays = pkgs.writeShellApplication {
    name = "displays";
    text = ''
    readarray -t displays < <(${pkgs.wlr-randr}/bin/wlr-randr --json | jq -r '.[] | select(.name != "${defaultDisplay}") | .name')
    if [[ -z "''${displays[*]}" ]]; then
      notify-send "Displays script" "No displays to configure" -u normal -t 1000
      exit 1
    fi

    display=$(printf "%s\n" "''${displays[@]}" | ${dmenucmd} -p "Choose display")
    if [[ -z "$display" ]]; then
      exit 1
    fi
    
    
    op1="Left"
    op2="Right"
    op3="Top"
    op4="OFF"
    op5="ON"
    options="Left\nRight\nTop\n"
    options="''${op1}\n''${op2}\n''${op3}\n''${op4}\n''${op5}"
    selected=$(echo -e "$options" | ${dmenucmd})

    case "$selected" in
      "$op1")
        ${pkgs.wlr-randr}/bin/wlr-randr --output "$display" --left-of ${defaultDisplay}
        ;;
      "$op2")
        ${pkgs.wlr-randr}/bin/wlr-randr --output "$display" --right-of ${defaultDisplay}
        ;;
      "$op3")
        ${pkgs.wlr-randr}/bin/wlr-randr --output "$display" --above ${defaultDisplay}
        ;;
      "$op4")
        ${pkgs.wlr-randr}/bin/wlr-randr --output "$display" --off
        ;;
      "$op5")
        ${pkgs.wlr-randr}/bin/wlr-randr --output "$display" --on
        ;;
      *)
        notify-send "Displays script" "Invalid option" -u normal -t 1000
        exit 1
        ;;
      esac
    '';
  };
}
