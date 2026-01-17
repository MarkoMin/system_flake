{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs_24.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs_25_05.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs_25_11.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
        inherit system;
        config = {
            allowUnfree = true;
            permittedInsecurePackages = ["nix-2.15.3"];
        };
    };

    pkgs-24 = import inputs.nixpkgs_24{
        inherit system;
        config = {
            allowUnfree = true;
        };
    };  

    pkgs-25-05 = import inputs.nixpkgs_25_05{
        inherit system;
        config = {
            allowUnfree = true;
        };
    };

    pkgs-25-11 = import inputs.nixpkgs_25_11{
        inherit system;
        config = {
            allowUnfree = true;
        };
    };

    pkgs-unstable = import inputs.unstable{
        inherit system;
        config = {
            allowUnfree = true;
        };
    };  
    in
  {
    nixosConfigurations = {
        myNixos = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system pkgs-unstable pkgs-24 pkgs-25-05 pkgs-25-11; };
            modules = [
                ./nixos/configuration.nix
            ];
        };
    };
  };
}
