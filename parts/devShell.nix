{...}: {
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
        alias png-to-avif="for f in *.png; do avifenc "$f" "$(basename "$f" .png).avif" && rm "$f"; done"
      '';
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [bash];
        packages = with pkgs; [
          hugo
          chromium
          skopeo
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
