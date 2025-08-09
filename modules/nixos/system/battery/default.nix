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
  # hostname = cfg.hostname;
in
{
  options.system.battery = with types; {
    enable = mkEnableOption "Enable battery optimization";
    # hostname = mkOpt types.str "thinkpad" "Hostname (used to determine monitor settings)";
  };

  config = mkIf cfg.enable {
    services.tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    # Disable GNOMEs power management (conflicts with TLP)
    services.power-profiles-daemon.enable = false;

    # Enable powertop
    powerManagement.powertop.enable = true;

    # Enable thermald (only necessary if on Intel CPUs)
    services.thermald.enable = true;

    services.upower.enable = true;
  };
}
