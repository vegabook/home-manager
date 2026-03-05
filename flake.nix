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
        # Linux configurations
        "tbrowne@x86_64-linux" = mkHome "x86_64-linux";
        "tbrowne@aarch64-linux" = mkHome "aarch64-linux";

        # macOS configurations
        "tbrowne@aarch64-darwin" = mkHome "aarch64-darwin";
        "tbrowne@x86_64-darwin" = mkHome "x86_64-darwin";

        # Default for backwards compatibility (Linux x86_64)
        "tbrowne" = mkHome "x86_64-linux";
      };
    };
}
