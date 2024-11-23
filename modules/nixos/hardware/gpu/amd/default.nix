{
  pkgs,
  lib,
  config,
  ...
}:
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
    boot.kernelParams = [ "amd_pstate=active" ]; # enable pstate

    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.amdgpu = {
      amdvlk.enable = true;
      opencl.enable = true;
      initrd.enable = true;
    };
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr
      ];
    };
    environment.systemPackages = with pkgs; [
      amdgpu_top
    ];
  };
}
