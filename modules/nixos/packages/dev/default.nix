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
      gdb
      cmake
      lldb
      valgrind
      criterion

      # Web:
      nodePackages_latest.nodejs
      nodePackages_latest.typescript
      bun

      # IDEs & editors:
      # neovim
      jetbrains.idea-ultimate
      jetbrains.datagrip
      vscodium
      neovide
      zed-editor
      renderdoc

      # Languages
      python312Packages.python
      lua

      # Tools
      wget
      curl
      xh
      atac
      yq
      jqp
      atuin

      # Posix utils:
      man-pages
      man-pages-posix
      moreutils
      file

      # OpenGL debugging:
      mesa-demos
      glxinfo
      clinfo
    ];
  };
}
