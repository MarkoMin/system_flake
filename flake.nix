{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
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
            specialArgs = { inherit inputs system pkgs-unstable; };
            modules = [
                ./nixos/configuration.nix
            ];
        };
    };
  };
}
