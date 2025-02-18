{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.scripts.basic;
in
{
  options.scripts.dmenucmd = mkOpt types.str "${pkgs.rofi-wayland} -show drun" "dmenu-like prompt program";
  options.scripts.basic = {
    enable = mkOpt types.bool true "Enable basic scripts";
  };

  config = mkIf cfg.enable {

    home.packages = [
      (import ./audioswitcher.nix { inherit pkgs config; })
      (import ./youtube-rss.nix { inherit pkgs; })
      (import ./newnote.nix { inherit pkgs; })
      (import ./autobisync.nix { inherit pkgs; })
      (import ./rclone_wrapper.nix { inherit pkgs; })
      (import ./volumecontrol.nix { inherit pkgs; })
      (import ./syncmenu.nix { inherit pkgs config; })
    ];
  };
}
