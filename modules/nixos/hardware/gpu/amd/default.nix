{ lib, config, ... }:
with lib;
with lib.dotfiles;
let
  cfg = config.hardware.gpu.amd;
in
{

  options.hardware.gpu.amd = with types; {
    enable = mkOpt types.bool false "Enable amdgpu config";
  };
  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelParams = [ "amd_pstate=active" ]; # enable pstate

    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.graphics = {
      enable = true;
    };
  };
}
