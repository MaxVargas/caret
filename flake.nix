{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
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

      hakyll-site = pkgs.haskellPackages.callPackage ./site { };
      website = pkgs.stdenv.mkDerivation {
        name = "website";
        src  = pkgs.nix-gitignore.gitignoreSourcePure [
          ./.gitignore
          ".git"
          ".github"
        ] ./.;
        LANG = "en_US.UTF-8";
        LOCALE_ARCHIVE = pkgs.lib.optionalString
          (pkgs.stdenv.buildPlatform.libc == "glibc")
          "${pkgs.glibcLocales}/lib/locale/locale-archive";

        buildInputs = with pkgs; [
          dart-sass
          zlib
        ];

        buildPhase = ''
          ${hakyll-site}/bin/caret build --verbose
        '';

        installPhase = ''
          mkdir -p "$out/plop"
          cp -a plop/. "$out/plop"
        '';
      };
      
    in {
      # nix build
      packages.${system} = {
        inherit hakyll-site website;
        default = website;
      };

      apps.${system} = {
        default = flake-utils.lib.mkApp {
          drv = hakyll-site;
          exePath = "/bin/caret";
        };
      };

      # nix develop
      devShells.${system}.default = hPkgs.shellFor {
        packages          = p: [ p.site ];
        nativeBuildInputs = [ hPkgs.haskell-language-server ];
        buildInputs       = with pkgs; [
          optipng
          zlib
          html-tidy
          linkchecker
          # KaTeX rendering of math
          katex
          dart-sass
        ];
        shellHook = ''
          export PROJECT_ROOT="$(pwd)"
          cabal run caret -- clean && cabal run caret -- build
        '';
      };

      # `nix fmt` formats the Nix files in this template
      formatter.${system} = pkgs.nixpkgs-fmt;
      # `nix flake check` builds the site
      checks = { inherit website; };
    };
}
