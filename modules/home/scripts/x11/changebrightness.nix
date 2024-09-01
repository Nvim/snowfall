{ pkgs }:
pkgs.writeShellScriptBin "changebrightness" ''
  send_notification() {
    brightness=$(printf "%.0f\n" "$(${pkgs.brillo}/bin/brillo)")
  	dunstify -a "changebrightness" -u low -r 9991 -h int:value:"$brightness" -i "brightness-$1" "Brightness: $brightness%" -t 2000
  }
  case $1 in
  up)
  	${pkgs.brillo}/bin/brillo -A 5 -q
  	# xbacklight -inc 5
  	send_notification "$1"
  	;;
  down)
  	${pkgs.brillo}/bin/brillo -U 5 -q
  	# xbacklight -dec 5
  	send_notification "$1"
  	;;
  esac
''
