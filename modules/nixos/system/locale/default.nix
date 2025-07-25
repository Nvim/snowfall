{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.system.locale;
in
{
  options.system.locale = with types; {
    enable = mkOpt types.bool true "Enable locale settings";
  };

  config = mkIf cfg.enable {
    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # Configure console keymap
    console.keyMap = "us";
  };
}
