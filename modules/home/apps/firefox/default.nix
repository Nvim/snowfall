{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.apps.firefox;
  profileName = cfg.profileName;
in
{
  options.apps.firefox = with types; {
    enable = mkOpt bool true "Enable firefox";
    profileName = mkOpt types.str "Default" "Firefox profile name";
  };
  config = mkIf cfg.enable {
    home.file.".mozilla/firefox/${profileName}/user.js" = {
      source = ./user.js;
    };
    programs.firefox = {
      enable = true;
      profiles.${profileName} = {
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          darkreader
          keepassxc-browser
          multi-account-containers
          gruvbox-dark-theme
          # tridactyl
        ];
      };
    };
  };
}
