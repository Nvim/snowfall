{
  channels,
  lib,
  ...
}:
final: prev: {
  inherit (channels.nixpkgs-stable) nerdfonts;
}
