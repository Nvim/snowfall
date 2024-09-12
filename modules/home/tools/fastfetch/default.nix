{
  inputs,
  pkgs,
  config,
  ...
}:
{
  home.file."${config.xdg.configHome}/fastfetch/config.jsonc" = {
    source = ./config.jsonc;
  };

}
