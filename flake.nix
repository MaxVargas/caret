{
  description = "hakyll-nix";

  nixConfig = {
    bash-prompt = "[hakyll-nix]λ ";
  };

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
          });
    in
    {
      devShells = forAllSystems ({ pkgs }:
        let
          hpkgs = pkgs.haskellPackages;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              hpkgs.ghc
              hpkgs.cabal-install
              hpkgs.pandoc
              zlib
              katex
              dart-sass
            ];
          };
        });
      packages = forAllSystems ({ pkgs }:
        {
          default = pkgs.haskellPackages.callCabal2nix
            "caret"
            ./. {};
        });
    };
}
