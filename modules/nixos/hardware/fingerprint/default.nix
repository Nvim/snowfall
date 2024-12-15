{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;

let
  cfg = config.hardware.fingerprint;
  fpcbep = pkgs.fetchzip {
    url = "https://download.lenovo.com/pccbbs/mobiles/r1slm01w.zip";
    hash = "sha256-/buXlp/WwL16dsdgrmNRxyudmdo9m1HWX0eeaARbI3Q=";
    stripRoot = false;
  };
  libfprint = pkgs.libfprint.overrideAttrs (attrs: {
    version = "1.94.6";
    src = pkgs.fetchgit {
      url = "https://gitlab.freedesktop.org/libfprint/libfprint.git";
      rev = "v1.94.6";
      sha256 = "sha256-lDnAXWukBZSo8X6UEVR2nOMeVUi/ahnJgx2cP+vykZ8=";
    };
    patches = attrs.patches or [ ] ++ [
      (pkgs.fetchpatch {
        url = "https://gitlab.freedesktop.org/libfprint/libfprint/-/merge_requests/396.patch";
        sha256 = "sha256-+5B5TPrl0ZCuuLvKNsGtpiU0OiJO7+Q/iz1+/2U4Taw=";
      })
    ];
    postPatch =
      (attrs.postPatch or "")
      + ''
        substituteInPlace meson.build \
          --replace "find_library('fpcbep', required: true)" "find_library('fpcbep', required: true, dirs: '$out/lib')"
      '';
    preConfigure =
      (attrs.preConfigure or "")
      + ''
        install -D "${fpcbep}/FPC_driver_linux_27.26.23.39/install_fpc/libfpcbep.so" "$out/lib/libfpcbep.so"
      '';
    postInstall =
      (attrs.postInstall or "")
      + ''
        install -Dm644 "${fpcbep}/FPC_driver_linux_libfprint/install_libfprint/lib/udev/rules.d/60-libfprint-2-device-fpc.rules" "$out/lib/udev/rules.d/60-libfprint-2-device-fpc.rules"
        substituteInPlace "$out/lib/udev/rules.d/70-libfprint-2.rules" --replace "/bin/sh" "${pkgs.runtimeShell}"
      '';
  });
  fprintd = pkgs.fprintd.override { inherit libfprint; };
in
{
  options.hardware.fingerprint = with types; {
    enable = mkOpt types.bool false "Enable fprint service";
  };

  config = mkIf cfg.enable {

    services.fprintd = {
      enable = true;
      package = fprintd;
    };

    services.udev = {
      enable = true;
      packages = [ libfprint ];
    };

    systemd.services.fprintd = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };
  };
}
