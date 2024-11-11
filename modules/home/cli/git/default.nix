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
  programs.git.extraConfig = {
    merge = {
      conflictStyle = "diff";
    };
  };
}
