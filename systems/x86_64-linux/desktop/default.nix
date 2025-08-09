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
  services.udisks2.enable = true;

  # PERFORMANCE
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = [
    pkgs.linuxKernel.packages.linux_zen.cpupower
    pkgs.openrgb
  ];
  systemd.services.disable-boost = {
    description = "Disable CPU frequency boost with cpupower";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-fs.mount" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.linuxKernel.packages.linux_zen.cpupower}/bin/cpupower set --turbo-boost 0";
    };
  };

  boot = {
    bootspec.enable = true;
    kernelParams = [
      "amd_pstate=active" # CPU governor
      "split_lock_mitigate=off" # prevents some games from being slowed
      "random.trust_cpu=on" # pretty sure this is useless
      "nowatchdog=0"
    ];
    blacklistedKernelModules = [ 
      "sp5100_tco" 
      "k10temp" # temperature monitor, replaced by zenpower
    ];
    extraModulePackages = [ config.boot.kernelPackages.zenpower ];
    kernelModules = [ "zenpower" ];
  };

  # CUSTOM MODULES 
  desktop = {
    gnome.enable = false;
    hyprland.enable = false;
    river.enable = true;
    greetd.enable = true;
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
    kde.enable = false; # TODO: ffmpeg top-level broken
    latex.enable = false;
  };

  system = {
    battery.enable = false;
    # battery.hostname = hostname;
    boot.enable = true;
    cron.enable = false;
    cron.autobisync = false;
    dbus.enable = false;
    fonts.enable = true;
    kernel.zen.enable = true;
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
  };

  # systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  # For zsh completions:
  environment.pathsToLink = [ "/share/zsh" ];
}
