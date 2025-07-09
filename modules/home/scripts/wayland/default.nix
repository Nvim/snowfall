{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.scripts.wayland;
in
{
  options.scripts.wayland = {
    enable = mkOpt types.bool true "Enable wayland scripts";
  };

  config = mkIf cfg.enable {

    home.packages =
      builtins.attrValues (
        import ./hctl.nix {
          inherit pkgs;
          inherit config;
        }
      )
      ++
      builtins.attrValues (
        import ./displays.nix {
          inherit pkgs;
          inherit config;
        }
      )
      ++
      builtins.attrValues (
        import ./power-menu.nix {
          inherit pkgs;
        }
      )
      ++ [
        # (import ./displays.nix { inherit pkgs; inherit config; })
        # (import ./kblayout.nix { inherit pkgs; inherit config; })
        # (import ./power-menu.nix { inherit pkgs; })
      ];
    #(import ./bookmarks.nix { inherit pkgs; })

  };
}
