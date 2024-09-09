{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.scripts.x11;
in
{
  options.scripts.x11 = {
    enable = mkOpt types.bool true "Enable x11-specific scripts";
  };

  config = mkIf cfg.enable {

    home.packages = [
      (import ./setbg.nix { inherit pkgs; })
      (import ./changebrightness.nix { inherit pkgs; })
      (import ./sb-battery.nix { inherit pkgs; })
      (import ./power-menu.nix { inherit pkgs; })
      # (import ./sb-volume.nix { inherit pkgs; })
    ];
  };
}
