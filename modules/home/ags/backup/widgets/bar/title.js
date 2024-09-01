const hyprland = await Service.import("hyprland");

export const ClientTitle = () =>
  Widget.Label().hook(
    hyprland,
    (self) => {
      // self.label = `${hyprland.getClient(hyprland.active.client.address).initialTitle}`;
      self.label = `${hyprland.active.client.title}`;
      self.class_name = "client-title";
    },
    "event",
  );
