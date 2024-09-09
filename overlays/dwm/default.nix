{ ... }:
final: prev: {
  dwm = prev.dwm.overrideAttrs (old: {
    src = ../../dwm;
  });
}
