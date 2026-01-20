---
date: 2025 March
tags:
  - nixos
---
An outline of the configuration structure I'm using while learning NixOS. A lot of this structure is influenced by the content in the [NixOS & Flakes Book by Ryan Yin](https://nixos-and-flakes.thiscute.world/) and is based off of the author's [i3-kickstarter](https://github.com/ryan4yin/nix-config/tree/i3-kickstarter).

File structure:
```nix
/etc/nixos/
├── flake.lock
├── flake.nix
├── home-manager
│   ├── core.nix
│   ├── programs
│   │   ├── apps.nix
│   │   ├── browsers.nix
│   │   ├── common.nix
│   │   ├── config
│   │   │   ├── hyprland.conf
│   │   │   └── start.sh
│   │   ├── default.nix
│   │   └── desktop.nix
│   └── shell
│       ├── common.nix
│       ├── default.nix
│       └── terminals.nix
├── nixos
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── users
    └── max
        ├── home.nix
        └── nixos.nix
```

`flake.nix` is the entry point for all the rest of the files. It uses `nixos/configuration.nix` as a module, along with `users/max/nixos.nix` for any user-relevant info like an SSH key. It also sets up `home-manager` so that you can handle user profiles more easily through something like `users/max/home.nix`.
- `nixos/configuration.nix` is the system-level config. I use this mostly to define system-level options as well as services. It has some basic user definitions in there along with an import for `nixos/hardware-configuration.nix`, which is typically left untouched.
- `users/max/home.nix` called through `home-manager` to configure the user profile(s). Mainly used to point at and load in some of the modules over in the `home-manager` directory.
I shouldn't try to give a full explanation here -- that's what those explanations over in the Flakes book is for. Instead, I'll just make note of a few things.

-----------------------

- To run nvidia things, you need to set `nixpkgs.allowUnfree = true;` in `nixos/configuration.nix`. Then you'll also want the following block
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia.open = true;
hardware.graphics.enable = true;
```
- I saw a comment somewhere that steam can be buggy if deploying with home-manager. So easiest to set it directly in the config, though this makes it a system-wide application... not a huge issue for me since I'm running a single-user system:
```nix
programs.steam = {
  enable = true;
  gamescopeSession.enable = true;
  package = pkgs.steam.override = {
    extraPkgs = pkgs:
      with pkgs; [
        liberation_ttf
      ];
  };
};
hardware.steam-hardware.enable = true;
programs.gamemode.enable = true;
```

------------------
Cachix is a nice service to download package binaries. This lets you save time so that you don't have to compile large packages on your own system. Feel free to explore the [site](https://app.cachix.org/). As an example, if you want to run [Hyprland](https://hyprland.org/), you can include the following in your configuration.
```nix
nix.settings.substituters = [
  ...
  "https://hyprland.cachix.org"
];

nix.settings.trusted-public-keys = [
  ...
  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
];

```