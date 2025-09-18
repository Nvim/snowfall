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

      # C/CPP
      gcc
      gnumake
      # cmake
      # lldb
      # valgrind
      # criterion
      # gdbgui

      # IDEs & editors:
      # neovim
      # jetbrains.idea-ultimate
      # jetbrains.datagrip
      vscodium
      # zed-editor
      # renderdoc

      # Languages
      python313Packages.python
      lua

      # Tools
      wget
      curl
      # xh
      # atac
      yq
      jqp
      # atuin

      # Posix utils:
      man-pages
      man-pages-posix
      moreutils
      file
      pstree

      # OpenGL debugging:
      # mesa-demos
      # glxinfo
      # clinfo
    ];
  };
}
