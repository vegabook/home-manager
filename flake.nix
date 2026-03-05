{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, ... }:
    let
      # Helper function to create home configuration for each system
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./home.nix
          sops-nix.homeManagerModules.sops
        ];
      };
    in {
      homeConfigurations = {
        # Linux configuration
        "tbrowne" = mkHome "x86_64-linux";

        # macOS configuration (if needed on different machines)
        "tbrowne@aarch64-darwin" = mkHome "aarch64-darwin";
        "tbrowne@x86_64-darwin" = mkHome "x86_64-darwin";
      };
    };
}
