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

  desktop = {
    gnome.enable = false;
    dwm.enable = true;
    hyprland.enable = false;
  };

  gaming.enable = false;

  hardware = {
    audio.enable = true;
    bluetooth.enable = true;
    gpu.amd.enable = false;
    networking.enable = true;
    networking.hostname = hostname;
    sleepfix.enable = false;
  };

  packages = {
    basics.enable = true;
    dev.enable = true;
    gtk.enable = true;
    latex.enable = false;
  };

  system = {
    battery.enable = true;
    boot.enable = true;
    fonts.enable = true;
    kernel.enable = true;
    ld.enable = true;
    locale.enable = true;
    nix.enable = true;
    virtualisation.enable = false;
    virtualisation.username = "naim";
    xkb.enable = true;
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
      "video"
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

  environment.systemPackages = with pkgs; [
    mesa
    intel-gpu-tools
  ];

  # For zsh completions:
  environment.pathsToLink = [ "/share/zsh" ];
}
