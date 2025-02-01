{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.packages.basics;
in
{
  options.packages.basics = {
    enable = mkOpt types.bool true "Enable basic packages";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [

      nh
      nix-output-monitor
      nvd
      nix-index
      nurl

      # apps:
      keepassxc
      obsidian
      rnote
      webcord
      spotify
      spicetify-cli
      firefox
      brave
      thunderbird-bin
      newsflash
      zathura
      libreoffice-qt-fresh
      upscaler
      parabolic
      mission-center
      cameractrls-gtk4

      # cli:
      gtypist
      glow
      pandoc
      fzf
      fd
      jq
      ripgrep
      tree
      fastfetch
      rclone
      btop
      ffmpeg
      lazygit
      ani-cli
      portal

      # utils:
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      age
      ssh-to-age
      libnotify
      git
      unzip
      brightnessctl
      bat
      eza
      appimage-run
      inputs.nix-alien.packages.${system}.nix-alien
    ];
  };
}
