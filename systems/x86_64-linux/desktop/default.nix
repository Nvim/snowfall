{
  lib,
  pkgs,
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  # All other arguments come from the system system.
  config,
  hostname,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  services.openssh.enable = true;

  desktop = {
    gnome.enable = false;
    hyprland.enable = true;
  };

  gaming.enable = true;

  hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    fingerprint.enable = false;
    gpu.amd.enable = true;
    networking.enable = true;
    networking.hostname = hostname;
    sleepfix.enable = true;
  };

  packages = {
    basics.enable = true;
    proton.enable = true;
    dev.enable = true;
    gtk.enable = true;
    kde.enable = true;
    latex.enable = false;
  };

  system = {
    battery.enable = true;
    battery.hostname = hostname;
    boot.enable = true;
    cron.enable = true;
    cron.autobisync = true;
    dbus.enable = false;
    fonts.enable = true;
    kernel.cachy.enable = true;
    ld.enable = true;
    locale.enable = true;
    nix.enable = true;
    virtualisation.enable = false;
    xkb.enable = true;
    xkb.qwerty = true;
  };

  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.naim = {
    isNormalUser = true;
    # hashedPasswordFile = config.sops.secrets.naim-password.path;
    description = "naim";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    createHome = true;
    shell = pkgs.zsh;
    packages = with pkgs; [ kitty ];
  };

  # services.xserver = {
  #   displayManager.gdm = {
  #     enable = true;
  #     wayland = true;
  #   };
  # };

  services.displayManager.ly.enable = true;
  # For zsh completions:
  environment.pathsToLink = [ "/share/zsh" ];
}
