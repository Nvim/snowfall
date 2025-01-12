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
  services.gvfs.enable = true;

  desktop = {
    gnome.enable = false;
    hyprland.enable = true;
  };

  gaming.enable = false;

  hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    fingerprint.enable = true;
    gpu.amd.enable = false;
    networking.enable = true;
    networking.hostname = hostname;
    sleepfix.enable = false;
    tablet.real = true;
  };

  packages = {
    basics.enable = true;
    proton.enable = true;
    dev.enable = true;
    gtk.enable = true;
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
    kernel.zen.enable = true;
    ld.enable = true;
    locale.enable = true;
    nix.enable = true;
    virtualisation.enable = true;
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
    shell = pkgs.zsh;
    packages = with pkgs; [ kitty ];
  };

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    videoDrivers = [
      "i915"
      "modesetting"
    ];
  };

  hardware.graphics = {
    enable = true;
  };

  boot = {
    initrd.systemd.enable = true;
    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  services.geoclue2.enable = true;

  # systemd.services."lockonsuspend@" = {
  #   unitConfig = {
  #     Description = "Lock screen on suspend";
  #     Before = [ "sleep.target" ];
  #   };
  #   wantedBy = [ "sleep.target" ];
  #   serviceConfig = {
  #     Type = "forking";
  #     ExecStart = ''${pkgs.hyprlock}/bin/hyprlock'';
  #     User = "%I";
  #   };
  #   environment = {
  #     DISPLAY = ":0";
  #   };
  # };
  # services.displayManager.ly.enable = true;

  # For zsh completions:
  environment.pathsToLink = [ "/share/zsh" ];
}
