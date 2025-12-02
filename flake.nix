{
  inputs = {
    # Rolling Release of Nixpkgs
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      pkgs,
      ...
    }: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "i686-linux"
      ];

      imports = [
        ./parts/devShell.nix
        ./parts/apps.nix
        ./parts/packages.nix
        ./parts/templates.nix
      ];
    });
}
