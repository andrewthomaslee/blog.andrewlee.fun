{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devShells = let
      bash_aliases = pkgs.writeText "bash_aliases" ''
        alias hs="nix run $REPO_ROOT#server"
        alias hc="nix run $REPO_ROOT#container"
      '';
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [bash];
        packages = with pkgs; [
          nginx
          hugo
        ];
        shellHook = ''
          export REPO_ROOT=$(git rev-parse --show-toplevel)
          export SHELL=$(which bash)
          if [ -f $REPO_ROOT/.env ]; then
            source $REPO_ROOT/.env
          fi
          source ${bash_aliases}
        '';
      };
    };
  };
}
