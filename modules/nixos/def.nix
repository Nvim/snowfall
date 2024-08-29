{
  lib,
  pkgs,
  inputs,
  system,
  config,
  ...
}:
with lib;
let
  cfg = config.def;
in
{
  options = {
    def = {
      enable = mkEnableOption "enable defaults";
    };
  };
  config = mkIf cfg.enable {
    # FIXME:
    networking.hostName = "desktop"; # Define your hostname.
    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Your configuration.
    # Enable xserver service (used for wayland too, idk what this does)
    services.xserver = {
      enable = true;
      # Configure keymap in X11
      xkb.layout = "fr";
      xkb.variant = "";
    };
    # Bootloader.
    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;

    # To fix GTK apps:
    programs.dconf.enable = true;

    # Bluetooth: TODO - Switch to different file, with more options(blueman/blueberry?)
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
    services.blueman.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";
    #
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
    console.keyMap = "fr";
    #
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
    #
    # Enable CUPS to print documents.
    services.printing.enable = false;

    # For zsh completions:
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
