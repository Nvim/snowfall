import { Volume, Mic } from "./widgets/bar/audio.js";
import { Clock } from "./widgets/bar/time.js";
import { Workspaces } from "./widgets/bar/workspaces.js";
import { ClientTitle } from "./widgets/bar/title.js";
import { SysTray } from "./widgets/bar/systray.js";
import { BatteryLabel } from "./widgets/bar/battery.js";
import { Media } from "./widgets/bar/multimedia.js";
import { Brightness, BrightnessPopup } from "./widgets/bar/brightness.js";

// import { applauncher } from "./widgets/applauncher.js";
import { NotificationPopups } from "./widgets/notificationPopups.js";

// layout of the bar
function Left() {
  return Widget.Box({
    spacing: 8,
    children: [Workspaces(), ClientTitle()],
  });
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [
      // Media(),
    ],
  });
}

function Right() {
  return Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [
      Mic(),
      Volume(),
      BatteryLabel(),
      Brightness(),
      Clock(),
      SysTray(),
    ],
  });
}

const Bar = (monitor = 0) =>
  Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      class_name: "bar_box",
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

App.config({
  style: "./style.css",
  windows: [
    Bar(),
    NotificationPopups(),
    BrightnessPopup(),
    // applauncher,
  ],
});

export { };

// Utils.timeout(100, () =>
//   Utils.notify({
//     summary: "Notification Popup Example",
//     iconName: "info-symbolic",
//     body:
//       "Lorem ipsum dolor sit amet, qui minim labore adipisicing " +
//       "minim sint cillum sint consectetur cupidatat.",
//     actions: {
//       Cool: () => print("pressed Cool"),
//     },
//   }),
// );
