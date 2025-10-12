{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.dotfiles;
let
  cfg = config.tools.stylix;
  firefoxProfile = config.apps.firefox.profileName;
  hostname = cfg.hostname;
  wallp = ../../../../wallp/gruvbox/painting.jpg;
  cursorSize = if hostname == "desktop" then 16 else 12;
  termFontSize =
    if hostname == "desktop" then
      15
    else if hostname == "hp-laptop" then
      10
    else
      13;
  appFontSize =
    if hostname == "desktop" then
      12
    else if hostname == "hp-laptop" then
      10
    else
      11;
in
{
  imports = [ inputs.stylix.homeModules.stylix ];
  options.tools.stylix = {
    enable = mkOpt types.bool false "Enable stylix";
    hostname = mkOpt types.str "desktop" "Hostname (used to determine monitor settings)";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = true;

      opacity.terminal = 0.95;
      image = wallp;
      polarity = "dark";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

      # custom zenbones dark (based on neovim/Ghostty)
      # override = {
      #   base00 = "#1C1917";
      #   base01 = "#2E2927";
      #   base02 = "#433C39";
      #   base03 = "#59514D";
      #   base04 = "#867A74";
      #   base05 = "#B4BDC3";
      #   base06 = "#B4BDC3";
      #   base07 = "#C4CACF";
        # From Ghostty:
        # base08 = "#de6e7c";
        # base09 = "#b77e64";
        # base0A = "#E0CF9F"; # this one still from nvim
        # base0B = "#819b69";
        # base0C = "#66a5ad";
        # base0D = "#315167"; # nvim as well
        # base0E = "#b279a7";
        # base0F = "#403833";
        # Extracted from nvim:
        # base08 = "#CB7A83";
        # base09 = "#DFAF8F";
        # base0A = "#E0CF9F";
        # base0B = "#5F7F5F";
        # base0C = "#66A5AD";
        # base0D = "#315167";
        # base0E = "#B279A7";
        # base0F = "#55392C";
      # };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = appFontSize;
          terminal = termFontSize;
        };
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        # package = pkgs.nordzy-cursor-theme;
        # name = "Nordzy-cursors";
        size = cursorSize;
      };

      targets = {
        ghostty.enable = true; # use ghostty's builtin zenbones
        river.enable = true;
        fontconfig.enable = false;
        firefox = {
          profileNames = [ firefoxProfile ];
          colorTheme.enable = false; # clashes with extensions
        };
        starship.enable = false;
        nixvim.enable = false;
        neovim.enable = false;
        vim.enable = true;
        i3bar-river.enable = false;
        waybar = {
          enable = false;
          addCss = true;
          enableCenterBackColors = true;
          enableLeftBackColors = true;
          enableRightBackColors = true;
        };
        zellij.enable = false;
        avizo.enable = false;
        hyprland.enable = true;
        hyprlock.enable = false;
        tofi.enable = false;
        tmux.enable = true;
        qt.enable = true;
        gtk = {
          enable = true;
          extraCss = ''
            /* No (default) title bar on wayland */
            headerbar.default-decoration {
              /* You may need to tweak these values depending on your GTK theme */
              margin-bottom: 50px;
              margin-top: -100px;
            }

            /* rm -rf window shadows */
            window.csd,             /* gtk4? */
            window.csd decoration { /* gtk3 */
              box-shadow: none;
            }
          '';
        };
      };
    };
    #
    gtk.iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
      # name = "Nordzy";
      # package = pkgs.nordzy-icon-theme;
    };
  };
}
