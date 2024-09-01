{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.latex;
in
{
  options.packages.latex = {
    enable = mkEnableOption "Enable Latex support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      texlive.combined.scheme-full
      zathura
      pandoc
    ];
  };
}
