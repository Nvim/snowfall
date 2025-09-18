{
  description = "Why?";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.11"; # Pin stable for nerdfonts
    # nixpkgs-limefix.url = "github:nixos/nixpkgs?rev=efabdd83aaa48154cb63515771c435f36adb7d24";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # nix-alien.url = "github:thiagokokada/nix-alien";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # xremap = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # hycov = {
    #   url = "github:DreamMaoMao/hycov";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # pyprland.url = "github:hyprland-community/pyprland";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # prismlauncher = {
      # url = "github:PrismLauncher/PrismLauncher";
      # Optional: Override the nixpkgs input of prismlauncher to use the same revision as the rest of your flake
      # Note that this may break the reproducibility mentioned above, and you might not be able to access the binary cache
      #
      # inputs.nixpkgs.follows = "nixpkgs";
    # };
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

      # System modules:
      # systems.modules.nixos = with inputs; [
      #   xremap.nixosModules.default
      # ];

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
