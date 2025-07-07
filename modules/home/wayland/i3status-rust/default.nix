{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.wayland.i3status-rust;
in
{
  options.wayland.i3status-rust = {
    enable = mkOpt types.bool false "Enable i3status-rust";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      i3status-rust
    ];
    home.file."${config.xdg.configHome}/i3status-rust/config.toml" = {
      source = ./config.toml;
    };

    # TODO: there's a hm module
  };
}
