{ lib, config, ... }:
with lib;
with lib.dotfiles;
let
  cfg = config.hardware.sleepfix;
in
{

  options.hardware.sleepfix = with types; {
    enable = mkOpt types.bool false "Sleep fix";
  };

  config = mkIf cfg.enable {

    # Disable devices on startup:
    systemd.tmpfiles.rules = [
      "w+   /proc/acpi/wakeup     -    -    -    -   GPP0"
      "w+   /proc/acpi/wakeup     -    -    -    -   GPP7"
      "w+   /proc/acpi/wakeup     -    -    -    -   GPP8"
      "w+   /proc/acpi/wakeup     -    -    -    -   GP17"
      "w+   /proc/acpi/wakeup     -    -    -    -   XHC0"
      "w+   /proc/acpi/wakeup     -    -    -    -   XHC1"
      "w+   /proc/acpi/wakeup     -    -    -    -   XHC2"
      "w+   /proc/acpi/wakeup     -    -    -    -   XH00"
    ];
  };
}
