{
  description = "Python 3.11 development environment";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; # also valid: "nixpkgs"
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      # Development environment output
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          # The Nix packages provided in the environment
          packages = with pkgs; [
            python313
            python313Packages.pandas
            python313Packages.polars
            python313Packages.numpy
            python313Packages.scipy
            python313Packages.scikit-learn
            python313Packages.matplotlib
            python313Packages.ipython
            python313Packages.requests
            python313Packages.aiohttp
            python313Packages.gql
            python313Packages.pathlib2
            python313Packages.pip
            python313Packages.pyarrow
          ];
        };
      });
    };
}
