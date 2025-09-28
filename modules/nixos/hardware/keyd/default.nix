{
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.hardware.keyd;
in
{
  options.hardware.keyd = with types; {
    enable = mkOpt types.bool true "Enable keyd remapping";
  };

  config = mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              # esc = capslock;
            };
          };
        };
      };
    };
  };
}
