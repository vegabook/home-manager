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
      # Helper function to create home configuration for each system/hostname
      mkHome = system: hostname: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit hostname; };
        modules = [
          ./home.nix
          sops-nix.homeManagerModules.sops
        ];
      };
    in {
      homeConfigurations = {
        # Linux configurations
        "tbrowne@x86_64-linux" = mkHome "x86_64-linux" "bee";
        "tbrowne@aarch64-linux" = mkHome "aarch64-linux" "rpi4";

        # macOS configurations
        "tbrowne@aarch64-darwin" = mkHome "aarch64-darwin" "Mac";
        "tbrowne@x86_64-darwin" = mkHome "x86_64-darwin" "logicLHR";

        # Default for backwards compatibility (Linux x86_64)
        "tbrowne" = mkHome "x86_64-linux" "bee";
      };
    };
}
