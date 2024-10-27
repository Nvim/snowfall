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
  imports = [ inputs.arkenfox.hmModules.default ];

  options.apps.firefox = with types; {
    enable = mkOpt bool true "Enable firefox";
    profileName = mkOpt types.str "Default" "Firefox profile name";
    arkenfox = mkOpt bool false "Enable Arkenfox";
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      arkenfox = {
        enable = cfg.arkenfox;
        version = "128.0";
      };
      profiles.${profileName} = {
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          darkreader
          keepassxc-browser
          # tridactyl
        ];
        arkenfox = {
          enable = cfg.arkenfox;
          "0000".enable = true;
          "0100" = {
            enable = true;
            "0102"."browser.startup.page".value = 1; # startup page
          };
          "0200".enable = true;
          "0300".enable = true;
          "0400".enable = true;
          "0600".enable = true;
          "0700".enable = true;
          "0800" = {
            enable = true;
            "0803"."browser.search.suggest.enabled".value = true;
            "0803"."browser.urlbar.suggest.searches".value = true;
          };
          "0900".enable = true;
          "1000" = {
            enable = true;
            "1001"."browser.cache.disk.enable".value = true;
          };
          "1200".enable = true;
          "1600".enable = true;
          "1700".enable = true;
          "2000".enable = true;
          "2400".enable = true;
          "2600" = {
            enable = true;
            # The recent documents feature is useful
            "2653".enable = false;
          };
          "2700".enable = true;
          "2800".enable = true;
          "4000".enable = true;
          "4500".enable = true;
          "5000".enable = true;
          "5500".enable = true;
          "6000".enable = true;
          "7000".enable = true;
        };
      };
    };
  };
}
