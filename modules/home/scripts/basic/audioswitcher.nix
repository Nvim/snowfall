{ pkgs }:
pkgs.writeShellApplication {
  name = "audioswitcher";
  runtimeInputs = [
    pkgs.rofi-wayland
    pkgs.wireplumber
  ];

  text = ''
    DAC () {
      wpctl set-default 88 &
      notify-send "Audio switched to DAC 🎶"
    }

    Speakers () {
      wpctl set-default 65 &
      notify-send "Audio switched to speakers 🔉"
    }

    choice=$(printf "DAC\\nSpeakers" | rofi -dmenu -i -p "🎛️ Choose output: ")
    case "$choice" in
      DAC) DAC;;
      Speakers) Speakers;;
    esac
  '';
}
