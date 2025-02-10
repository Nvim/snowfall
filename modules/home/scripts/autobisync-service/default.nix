{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.scripts.autobisync-service;
  script = import ../basic/autobisync.nix { inherit pkgs; };
in
{
  options.scripts.autobisync-service = with types; {
    enable = mkOpt types.bool true "Enable autobisync service";
    # autobisync = mkOpt types.bool false "Enable automatic bisync";
  };

  config = mkIf cfg.enable {
    systemd.user.services.autobisync-service = {
      Unit = {
        Description = "Run autobisync script in background";
        Wants = "autobisync-service.timer";
      };
      Service = {
        ExecStart = "${script}/bin/autobisync ING Obsidian Keepass";
        Type = "simple";
      };
    };

    systemd.user.timers.autobisync-service = {
      Unit.Description = "Run autobisync script in background";
      Timer.OnCalendar = "*:0/30";
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
