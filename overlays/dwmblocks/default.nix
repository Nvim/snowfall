{ ... }:
final: prev: {
  dwmblocks = prev.dwmblocks.overrideAttrs (old: {
    src = ../../dwmblocks;
  });
}
