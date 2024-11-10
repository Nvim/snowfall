{ channels, ... }:
final: prev: {

  xp-pen-deco-01-v2-driver = prev.xp-pen-deco-01-v2-driver.overrideAttrs (old: {
    # src = channels.nixpkgs.fetchzip {
    #   url = "https://www.xp-pen.com/download/file/id/2901/pid/846/ext/gz.html";
    #   hash = "sha256-0qw5vjjzfwf7abra703b3zqmzsvl8fydiwdyk7d2bbz172a96xv5=";
    # };
    # TODO: Make fetchzip work
    src = ./src;
  });
}
