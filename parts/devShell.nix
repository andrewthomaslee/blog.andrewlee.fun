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
        alias hp="nix run $REPO_ROOT#push"
        alias hn="hugo new $REPO_ROOT/hugo/content/post/title_of_the_post.md -s $REPO_ROOT/hugo"
      '';
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [bash];
        packages = with pkgs; [
          nginx
          hugo
          kubectl
          chromium
          tmux
          skopeo
          docker
          jq
          yq
          gzip
          libavif
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
