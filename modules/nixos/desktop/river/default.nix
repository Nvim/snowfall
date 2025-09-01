{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.desktop.river;
in
{
  options.desktop.river = {
    enable = mkEnableOption "Enable River NixOS module";
    enableFprint = mkOpt types.bool false "Enable fingerprint auth";
  };
  config = mkIf cfg.enable {

    programs.river = {
      enable = true;
      xwayland.enable = false;
      extraPackages = with pkgs; [
        river-filtile
        wl-color-picker
        libsForQt5.qt5ct
        swaybg
        slurp
        grim
        wf-recorder
        wl-clipboard
        wlr-randr
        pcmanfm
        (pkgs.rustPlatform.buildRustPackage rec {
          pname = "flow";
          version = "v0.2.0";

          src = pkgs.fetchFromGitHub {
            owner = "stefur";
            repo = "flow";
            rev = version;
            hash = "sha256-VVM6EuefMWlB3B6XUiGwx8MTmEIhPykLw0erdK1A5sE=";
          };

          cargoLock.lockFile = "${src}/Cargo.lock";
        })
      ];
    };

    security.pam.services.swaylock =
      if cfg.enableFprint then
        {
          enableGnomeKeyring = true; 
          fprintAuth = true;
          text = ''
            # account management.
            account required pam_unix.so

            # authentication management.

            # prompt for a password; pressing enter on a blank field will proceed to fingerprint authentication.
            auth sufficient pam_unix.so nullok likeauth try_first_pass
            auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
            auth required pam_deny.so

            # password management.
            password sufficient pam_unix.so nullok sha512

            # session management.
            session required pam_env.so conffile=/etc/pam/environment readenv=0
            session required pam_unix.so
          '';
        }
      else
        { };

    xdg.portal = {
      enable = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 60;
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          };
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal
      ];
      xdgOpenUsePortal = true;
    };

    # Enable gnome polkit
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    # GNOME keyring:
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = if cfg.enableFprint then true else false;
    security.pam.services.greetd-password.enableGnomeKeyring = if cfg.enableFprint then true else false;
    environment.systemPackages = [ pkgs.lssecret ];
  };
}
