{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  snowfallorg.user.name = "naim";
  cli.zsh.enable = true;
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
