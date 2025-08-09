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
    nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ [pkgs.nss];
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
  fprintd = (pkgs.fprintd.override { inherit libfprint; }).overrideAttrs (attrs: {
    version = "1.94.4";
    src = pkgs.fetchgit {
      url = "https://gitlab.freedesktop.org/libfprint/fprintd.git";
      rev = "v1.94.4";
      sha256 = "sha256-B2g2d29jSER30OUqCkdk3+Hv5T3DA4SUKoyiqHb8FeU";
    };
    nativeCheckInputs = with pkgs.python3Packages.pkgs; [
      gobject-introspection # for setup hook
      python-dbusmock
      dbus-python
      pygobject3
      pycairo
      pypamtest
      gusb # Required by libfprint’s typelib
    ];
    # nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ [pkgs.libpam-wrapper pkgs.python3Packages.pycairo pkgs.python3Packages.dbus-python pkgs.python3Packages.python-dbusmock pkgs.python3Packages.pypamtest pkgs.python3Packages.gusb];
    mesonCheckFlags = [
      "--no-suite"
      "fprintd:TestPamFprintd"
    ];
    doCheck = false;
  });
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
