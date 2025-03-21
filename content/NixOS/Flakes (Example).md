---
date: 2025 March
---
I've been curious to play around with some creative coding practices, for example [nannou](https://nannou.cc/). The installation wasn't trivial, mainly because of issues with `alsa` and still learning about the nix ecosystem.

Being a beginner with nix (i ought to go back and carefully read the docs now that I know how to get some basics set up), the setup I have is almost assuredly suboptimal, but if it works then it works.

------------
`nannou`

My first N attempts all found me staring at some issue with `alsa`... I eventually found my way to [Ninjaman10p's comment](https://www.reddit.com/r/NixOS/comments/1almuft/why_cant_nix_as_setup_by_cargo2nix_see_alsa_in_my/) to get an initial flake up and running for `nannou`. Unfortunately I still wasn't able to run any examples due to complaints with `rustPlatform.buildRustPackage`. Eventually the following `flake.nix` inside of the cloned `nannou` repo ended up working, following some tips I found [here](https://artemis.sh/2023/07/08/nix-rust-project-with-git-dependencies.html) about sha256 keys:
```
{
  description = "A very basic nannou";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    oxalica.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, oxalica }:
    with flake-utils.lib;
    eachSystem allSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend oxalica.overlays.default;
      in rec {
        packages = {
          
          nann = let
            rustPlatform = pkgs.makeRustPlatform {
              cargo = pkgs.rust-bin.stable.latest.minimal;
              rustc = pkgs.rust-bin.stable.latest.minimal;
            };
          in rustPlatform.buildRustPackage rec {
            name = "nann-demo";
            src = self;
            nativeBuildInputs = with pkgs; [ pkg-config ];
            buildInputs = with pkgs; [ alsa-lib.dev udev.dev ];
            cargoLock = { 
              lockFile = ./Cargo.lock; 
              outputHashes = {
                "hotglsl-0.1.0" = "sha256-G88Sa/tgGppaxIIPXDqIazMWRBXpaSFb2mulNfCclm8=";
                "isf-0.1.0" = "sha256-utexaXpZZgpRunVAQyD2JAwvabhZGzeorC4pRFIumAc=";
                "skeptic-0.13.4" = "sha256-EZFtWIPfsfbpGBD8NwsVtMzRM10kVdg+djoV00dhT4Y=";
              };
            };
          };
        };
        defaultPackage = packages.nann;
        formatter = pkgs.nixfmt;
      });
}
```
The flake got me through my `alsa` issues and other problems with miscellaneous packages, but now I needed the help of this [thread](https://github.com/nannou-org/nannou/issues/618) to take care of wayland issues that came up! 
```
let
  pkgs = import <nixpkgs> { };
in with pkgs;
mkShell {
  name = "nannou-sample";
  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.clang
    pkgs.lld
  ];
  buildInputs = with pkgs; [
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    vulkan-loader
    udev
    cmake
    gcc
    cargo
    rustc
  ];
  shellHook = ''
              export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
                pkgs.lib.makeLibraryPath [
                  udev
                  vulkan-loader
                ]
              }"'';
  RUST_SRC_PATH = rustPlatform.rustLibSrc;
}
```
With the first `flake.nix` file and second `shell.nix` file inside of `nannou`'s root directory, things were running smoothly.