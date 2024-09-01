{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.ld;
in
{

  options.system.ld = {
    enable = mkEnableOption "Enable nix-ld";
  };
  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [

      # Sane defaults:
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat

      # Zelda64:
      SDL2
      atk
      at-spi2-atk
      cairo
      fontconfig
      freetype
      gdk-pixbuf
      glib
      glibmm
      gtk3
      libgcc
      pango
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXext
      xorg.libXrandr
      xorg_sys_opengl

      # vulkan:
      spirv-tools
      spirv-headers
      vulkan-headers
      vulkan-extension-layer
      # vulkan-validation-layers
      vulkan-loader
    ];
  };
}
