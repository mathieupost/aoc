{
  description = "A basic Elixir development environment";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (pkgs.lib) optional optionals;
        pkgs = import nixpkgs { inherit system; };

        elixir = pkgs.beam.packages.erlang.elixir;
      in
      with pkgs;
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            elixir
            elixir_ls
            glibcLocales
            postgresql
          ] ++ optional stdenv.isLinux inotify-tools
          ++ optional stdenv.isDarwin terminal-notifier
          ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
            CoreFoundation
            CoreServices
          ]);

          PGHOST = "localhost";
          PGPORT = "5432";
          PGUSER = "postgres";
          PGDATABASE = "postgres";
          PGPASSWORD = "postgres";
          PGSSLMODE = "disable";

          shellHook = ''
            export PGDATA="$PWD/.direnv/pgdata"
            OLD_PGUSER=$PGUSER
            export PGUSER=
            [ ! -d $PGDATA ] &&
              echo "========== CREATING LOCAL DATABASE ==========" && \
              initdb && \
              pg_ctl -o "-p $PGPORT -k $PGDATA" start && \
              createuser -s $OLD_PGUSER && \
              pg_ctl stop && \
              export PGUSER=$OLD_PGUSER
              echo "========== DONE =========="
          '';
        };
      }
    );
}
