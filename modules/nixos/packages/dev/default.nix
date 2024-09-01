{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.dev;
in
{
  options.packages.dev = {
    enable = mkEnableOption "Enable dev packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wget
      curl
      neovim

      gcc
      gnumake
      cmake

      nodePackages_latest.nodejs
      nodePackages_latest.typescript
      bun

      python312Packages.python
      lua

      vscodium
    ];
  };
}
