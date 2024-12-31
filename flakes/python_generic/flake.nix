{
  description = "R development environment";

  # Flake inputs
  inputs = {
  	  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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
            clang
            jq
            tinymist
            typst
            uv
            python312
            python312Packages.distutils
            python312Packages.psycopg2
            python312Packages.pgvector
            python312Packages.faiss
            python312Packages.scikit-learn
            postgresql
            pgcli
            git-lfs
          ];
          shellHook = ''

            CREDENTIALS_FILE="credentials.json"
            if [[ ! -f $CREDENTIALS_FILE ]]; then
              echo "Error: Credentials file '$CREDENTIALS_FILE' not found!"
              exit 1
            fi
            while IFS='=' read -r KEY VALUE; do
              export "$KEY=$VALUE"
              echo "Exported: $KEY"
            done < <(jq -r 'to_entries[] | .key as $section | .value | to_entries[] | "\($section)_\(.key)=\(.value)"' "$CREDENTIALS_FILE")

            alias neopsql="PGHOST=$neonews_host PGPORT=$neonews_port PGUSER=$neonews_user PGPASSWORD=$neonews_pwd PGDATABASE=$neonews_dbname psql"
            alias tpsql="PGHOST=$transactions_host PGPORT=$transactions_port PGUSER=$transactions_user PGPASSWORD=$transactions_pwd PGDATABASE=$transactions_dbname psql"
            alias neocli="PGPASSWORD=$neonews_pwd pgcli --host $neonews_host --port $neonews_port --username $neonews_user --dbname $neonews_dbname"
            alias tcli="PGPASSWORD=$transactions_pwd pgcli --host $transactions_host --port $transactions_port --username $transactions_user --dbname $transactions_dbname"
            alias ipy="ipython --nosep --InteractiveShell.cache_size=0 --TerminalInteractiveShell.editing_mode=vi"
            alias vexit="deactivate && exit"

            export PS1="🔰 \e[38;5;220m\]Neo\e[38;5;76mneX\[\e[0m $PS1";

            # Create virtual environment if it 
            if [ ! -d .venv ]; then
              echo "Creating virtual environment with uv at .venv"
              uv venv
            fi

            # Activate the virtual environment
            echo "Activating virtual environment"
            source .venv/bin/activate

          '';
        };
      });
    };
}
