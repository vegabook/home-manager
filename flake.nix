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
        "bee" = mkHome "x86_64-linux" "bee";
        "logicLHR" = mkHome "x86_64-linux" "logicLHR";
        "rpi4" = mkHome "aarch64-linux" "rpi4";
        "Mac4" = mkHome "aarch64-darwin" "Mac4";
	      "mac10" = mkHome "aarch64-darwin" "mac10";
      };
    };
}
