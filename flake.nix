{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      # Only care about actual Haskell source files; this improves caching
      # behaviour.
      haskellSourceFilter = src: nixpkgs.lib.cleanSourceWith {
        inherit src;
        filter = name: type:
          let file = toString name;
              baseName = baseNameOf file;
          in nixpkgs.lib.cleanSourceFilter name type
             && (nixpkgs.lib.hasPrefix "site" baseName
                 || nixpkgs.lib.hasSuffix ".cabal" file
                 || nixpkgs.lib.hasSuffix ".project" file
                 || nixpkgs.lib.hasSuffix ".hs" file
                 || nixpkgs.lib.hasSuffix ".nix" file
             );
      };
      system = "x86_64-linux";
      pkgs   = import nixpkgs { inherit system; };
      hPkgs  = pkgs.haskellPackages.extend (self: super: {
        site            = self.callCabal2nix "site" (haskellSourceFilter ./.) { };
        hakyll = self.callCabal2nix "hakyll" (builtins.fetchGit {
          url = "https://github.com/jaspervdj/hakyll";
          rev = "92a5f884cbcfd9f2cd89d3e96f6c3f6ae3da7cec";
        }) {};
      });
    in {
      # nix build
      packages.${system}.default = hPkgs.site;

      # nix develop
      devShells.${system}.default = hPkgs.shellFor {
        packages          = p: [ p.site ];
        nativeBuildInputs = [ hPkgs.haskell-language-server ];
        buildInputs       = with pkgs; [
          optipng
          zlib
          html-tidy
          linkchecker
          # KaTeX rendering of maths, see scripts/maths.js
          katex
          dart-sass
        ];
        shellHook = ''
          export PROJECT_ROOT="$(pwd)"
          cabal run caret -- clean && cabal run caret -- build
        '';
      };
    };
}
