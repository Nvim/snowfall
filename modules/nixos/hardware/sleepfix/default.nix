{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hardware.sleepfix;
  disableWireless = pkgs.writeShellScriptBin "disable-wireless" ''
    #!/bin/sh
    case ${1} in
    pre)
    rmmod mt7921e
    echo "Removing mt7921e kernel module"
    ;;
    post)
    modprobe mt7921e
    echo "Adding mt7921e kernel module"
    ;;
    esac
  '';
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

    # Disable wifi/bluetooth:
    systemd.services.disable-wireless = {
      unitConfig = {
        Description = "Disable Wireless services before sleeping";
      };
      before = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill block all";
      };
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    };

    systemd.services.enable-wireless = {
      unitConfig = {
        Description = "Enable Wireless services after sleeping";
      };
      after = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock all";
      };
      wantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    };
  };
}
