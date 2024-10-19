const battery = await Service.import("battery");

function clampBattery(p) {
  if (p > 0 && p < 101) {
    p = p / 100;
  } else {
    p = 0;
  }
  return p;
}

export function BatteryLabel() {
  return Widget.Box({
    spacing: 4,
    // value: battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0)),
    // class_name: battery.bind("charging").as((ch) => (ch ? "charging" : "")),
    children: [
      Widget.Icon({
        icon: battery.bind("icon_name"),
        visible: battery.bind("available"),
      }),
      Widget.Label({
        label: battery.bind("percent").as((p) => `${p}%`),
      }),
    ],
  });
}
