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
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];
  desktop.gnome.enable = true;
  hardware.gpu.amd.enable = true;
  hardware.networking.hostname = "desktop";

  # For zsh completions:
  environment.pathsToLink = [ "/share/zsh" ];
}
