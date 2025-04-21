{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.dotfiles;

let
  cfg = config.system.virtualisation;
  username = cfg.username;
in
{
  options.system.virtualisation = {
    enable = mkOpt types.bool false "Enables virtualisation";
    username = mkOpt types.str "naim" "Username";
  };

  config = mkIf cfg.enable {
    # Virtualization settings
    programs.virt-manager.enable = true;

    users.extraGroups.libvirtd.members = [ username ];
    users.extraGroups.docker.members = [ username ];
    # extraGroups = [ "libvirtd" ];

    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = false;
        rootless = {
          enable = false;
          # setSocketVariable = true;
        };
      };
      # podman.enable = true;
      libvirtd = {
        enable = true;
        qemu = {
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };
      # spiceUSBRedirection = true;
    };
  };
}
