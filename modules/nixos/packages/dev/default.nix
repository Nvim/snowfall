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
      # neovim

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

      # Misc:
      python312Packages.python
      lua
      vscodium
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
