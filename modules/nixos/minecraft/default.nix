{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;

let
  cfg = config.minecraft;
in
{
  options.minecraft = with types; {
    enable = mkOpt types.bool false "Enable Minecraft";
  };
  config = mkIf cfg.enable {

    environment.systemPackages = [
      inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
    ];
    programs.gamemode.enable = true;

  };
}
