import brightness from "../../services/brightness.js";

const slider = Widget.Slider({
  on_change: (self) => (brightness.screen_value = self.value),
  value: brightness.bind("screen_value"),
  hexpand: true,
  drawValue: false,
});

const popupWidget = Widget.Box({
  spacing: 4,
  css: "min-width: 140px",
  child: slider,
});

export const BrightnessPopup = () =>
  Widget.Window({
    visible: false,
    name: "brightness-popup",
    class_name: "popup",
    anchor: ["top", "right"],
    child: popupWidget,
  });

const label = Widget.Label({
  label: brightness.bind("screen_value").as((v) => `${v}`),
  setup: (self) =>
    self.hook(
      brightness,
      (self, screenValue) => {
        // screenValue is the passed parameter from the 'screen-changed' signal
        self.label = `${screenValue}` ?? "0";

        // NOTE:
        // since hooks are run upon construction
        // the passed screenValue will be undefined the first time

        // all three are valid
        self.label = `${brightness.screen_value}`;
        self.label = `${brightness["screen-value"]}`;
      },
      "screen-changed",
    ),
});

export function Brightness() {
  const getIcon = () => {
    const icons = {
      67: "high",
      34: "medium",
      1: "low",
      0: "off",
    };
    const iconNum = [67, 34, 1, 0].find(
      (threshold) => threshold <= brightness.screen_value * 100,
    );
    return `display-brightness-${icons[iconNum]}-symbolic`;
  };
  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), brightness, getIcon),
  });
  const box = Widget.Box({
    spacing: 4,
    children: [icon, label],
  });

  return Widget.Button({
    child: box,
    on_clicked: () => App.toggleWindow("brightness-popup"),
  });
}
