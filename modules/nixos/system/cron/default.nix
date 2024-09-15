{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.system.cron;
in
{
  options.system.cron = with types; {
    enable = mkOpt types.bool true "Enable crontab service";
    autobisync = mkOpt types.bool false "Enable automatic bisync";
  };

  config = mkIf cfg.enable {
    services.cron.enable = true;
    services.cron.systemCronJobs = mkIf cfg.autobisync [
      "*/15 * * * * $HOME/.nix-profile/bin/autobisync Perso"
    ];
  };
}
