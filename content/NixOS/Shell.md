---
date: 2025 March
---
This is a very basic shell for ML / data science in python, setting up pytorch but very little else and you'll almost certainly want to add in extras. You can activate it with `nix-shell`. TODO: learn how to upgrade this the "flake way"?
```nix
{
  pkgs ? import <nixpkgs> { config = {allowUnfree=true;}; }
}:

pkgs.mkShell {
  name = "pytorch-ml-env";

  buildInputs = with pkgs; [
    git gitRepo gnupg autoconf curl
    procps gnumake util-linux m4 gperf unzip
    cudatoolkit linuxPackages.nvidia_x11
    libGLU libGL
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.X11 xorg.libXv xorg.libXrandr zlib
    ncurses5 stdenv.cc binutils
  ];

  packages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      notebook
      pandas
      numpy
      matplotlib
      plotly
      torch-bin
      torchvision-bin
      torchaudio-bin
  ]))
  ];

  shellHook = ''
    export CUDA_PATH=${pkgs.cudatoolkit}
    # export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
    export EXTRA_CCFLAGS="-I/usr/include"
  '';
}
```

Obviously you can include other, non-python packages inside of `packages`.

Note: Sometimes I get a strange error that yields unavailable CUDA devices. [This thread](https://discuss.pytorch.org/t/userwarning-cuda-initialization-cuda-unknown-error-this-may-be-due-to-an-incorrectly-set-up-environment-e-g-changing-env-variable-cuda-visible-devices-after-program-start-setting-the-available-devices-to-be-zero/129335/2) helps my system. In particular, once you launch `nix-shell` and if you're getting a "CUDA unknown error", try:
```
sudo rmmod nvidia_uvm
sudo modprobe nvidia_uvm
```
Then cuda will hopefully be available again.


--------------
FSH

I've been occasionally finding myself needing to start a FSH shell because some code bases like to use dynamically linked executables. The nix pages state [this is a last resort](https://nix.dev/guides/faq#how-to-run-non-nix-executables), but using a FSH shell seems to (me) be the quickest/easiest way around this. In the meantime I'll have to go back and pick up the fundamentals on how to "properly" resolve my issues. Anyways, here's a nix flake that you can use to load up an FSH shell. In this example, I am wanting to use the `uv` python package manager. 

```nix
{
  description = "Python 3.11 development environment";
  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    devShells.${system}.default = (pkgs.buildFHSEnv {
      name = "nvidia";
      targetPkgs = pkgs: (with pkgs; [
        linuxPackages.nvidia_x11
        libGLU libGL
        xorg.libXi xorg.libXmu freeglut
        xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib 
        ncurses5 stdenv.cc binutils
        ffmpeg

        # uv does the real legwork
        uv
      ]);

      profile = ''
          export LD_LIBRARY_PATH="${pkgs.linuxPackages.nvidia_x11}/lib"
          export CUDA_PATH="${pkgs.cudatoolkit}"
          export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
          export EXTRA_CCFLAGS="-I/usr/include"
      '';
    }).env;
  };
}
```