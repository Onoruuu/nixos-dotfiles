{
  description = "Aaron's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        # Acer Nitro 5 Configuration
        nixabyss-nitro = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/acer-nitro.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aaron = import ./home.nix;
            }
            hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };

        # Dell Latitude Configuration
        nixabyss-latitude = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/latitude.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aaron = import ./home.nix;
            }
            hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };

        # Dell Inspiron Configuration
        nixabyss-inspiron = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/inspiron.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.aaron = import ./home.nix;
            }
            hyprland.nixosModules.default
            { programs.hyprland.enable = true; }
          ];
        };
      };
    };
}
