{
  description = "Why?";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    ags.url = "github:Aylur/ags";

    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    matugen.url = "github:InioX/matugen?ref=v2.2.0";

    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {

      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "idk";
          title = "huh";
        };
        namespace = "dotfiles";
      };

      channels-config = {
        allowUnfree = true;
      };

      # Host-specific settings:
      systems.hosts.desktop.specialArgs = {
        hostname = "desktop";
        stateVersion = "23.11";
      };
      systems.hosts.hp-laptop.specialArgs = {
        hostname = "hp-laptop";
        stateVersion = "23.11";
      };
      systems.hosts.thinkpad.specialArgs = {
        hostname = "thinkpad";
        stateVersion = "23.11";
      };
      systems.hosts.thinkpad.modules = with inputs; [
        #
        lanzaboote.nixosModules.lanzaboote
      ];

      # Home modules:
      home.modules = with inputs; [
        stylix.homeManagerModules.stylix
        ags.homeManagerModules.default
        arkenfox.hMModules.default
      ];

      # Home-specific settings:
      homes.users."naim@desktop".specialArgs = {
        hostname = "desktop";
        username = "naim";
        stateVersion = "23.11";
      };
      homes.users."naim@thinkpad".specialArgs = {
        hostname = "thinkpad";
        username = "naim";
        stateVersion = "23.11";
      };
      homes.users."naim@hp-laptop".specialArgs = {
        hostname = "hp-laptop";
        username = "naim";
        stateVersion = "23.11";
      };
    };
}
