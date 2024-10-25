{
  channels,
  lib,
  ...
}:
# final: prev: {
#   inherit (channels.unstable) lime3ds ffmpeg_6-headless ffmpeg-headless;
#
#   final.lime3ds = prev.lime3ds.overrideAttrs (old: {
#     buildInputs = lib.remove ffmpeg-headless old.buildInputs ++ [ pkgs.ffmpeg_6-headless ];
#   });
# }
final: prev: {
  inherit (channels.nixpkgs-limefix) lime3ds;
}
