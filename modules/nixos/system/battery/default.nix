{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.system.battery;
  hostname = cfg.hostname;
in
{
  options.system.battery = with types; {
    enable = mkEnableOption "Enable battery optimization";
    hostname = mkOpt types.str "desktop" "Hostname (used to determine monitor settings)";
  };

  config = mkIf cfg.enable {
    # Better scheduling for CPU cycles - thanks System76!!!
    # services.system76-scheduler.enable = true;
    # services.system76-scheduler.settings.cfsProfiles.enable = true;

    # Enable TLP (better than gnomes internal power manager)
    services.tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    # Disable GNOMEs power management
    services.power-profiles-daemon.enable = false;

    # Enable powertop
    powerManagement.powertop.enable = if hostname == "desktop" then false else true;

    # Enable thermald (only necessary if on Intel CPUs)
    services.thermald.enable = if hostname == "desktop" then false else true;

    services.upower.enable = true;
  };
}
