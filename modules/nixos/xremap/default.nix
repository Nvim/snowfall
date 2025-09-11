{
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.xremap;
in
{
  options.xremap = {
    enable = mkOpt types.bool true "Enable xremap";
    username = mkOpt types.str "naim" "Username";
  };

  config = mkIf cfg.enable {
    services.xremap = {
      userName = cfg.username;
      withWlroots = true;
      yamlConfig = ''
        modmap:
          - name: main
            remap:
              CapsLock:
                held: leftctrl
                alone: esc
                alone_timecout_millis: 150
      '';
    };
  };
}
