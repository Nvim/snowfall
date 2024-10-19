const timeFetch = Variable("", {
  poll: [15000, 'date "+%H:%M"'],
});
const dateFetch = Variable("", {
  poll: [3600000, 'date "+%b %e"'],
});

export function Clock() {
  const date = Widget.Label({
    class_name: "clock",
    label: dateFetch.bind(),
  });
  const time = Widget.Label({
    class_name: "clock",
    label: timeFetch.bind(),
  });
  const iconTime = Widget.Icon({
    icon: "org.gnome.clocks-symbolic",
  });
  const iconCal = Widget.Icon({
    icon: "x-office-calendar",
  });
  const timeBox = Widget.Box({
    spacing: 4,
    children: [iconTime, time],
  });
  const dateBox = Widget.Box({
    spacing: 4,
    children: [iconCal, date],
  });
  return Widget.Box({
    spacing: 10,
    children: [timeBox, dateBox],
  });
}
