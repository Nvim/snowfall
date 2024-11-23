{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.cli.git;
in
{
  programs.git = {
    enable = true;
    userName = "Naim";
    userEmail = "naimssj4@gmail.com";
  };
}
