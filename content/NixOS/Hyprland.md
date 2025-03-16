---
date: 2025 March
---
I guess this is a way to organize your screen and applications to configurable tiles on your screen. Visually, I'm thinking tmux at the desktop layer..

As in other pages, I'm starting with Vimjoyer's [video](https://www.youtube.com/watch?v=61wGzIv12Ds). 
- What is a workspace?
	From the [wayland pages](https://wayland.app/protocols/ext-workspace-v1): workspaces, also called virtual desktops, are groups of surfaces. You can have multiple workspaces and the compositor (wayland) will display the surfaces corresponding from active workspaces. It will suppress surfaces from inactive ones.

As far as setting this thing up.... it was admittedly kind of a pain to get the initial launch working but I've made it and can write down the lessons I've learned.

------------------
`flake.nix`

Inside of `flake.nix`, you'll want to introduce hyprland to your inputs. Since I'm using home-manager to handle configuration, you need that too.
```
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  home-manager = {
    url = "github:nix-community/home-manager/release-24.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  hyprland = {
    url = "github:hyprwm/Hyprland";
  };
}
```
Further down, you'll want to include these inputs into `specialArgs` for your host as instructed in the [documentation](https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/):
```
outputs = {nixpkgs, ...} @ inputs: {
nixosConfigurations.HOSTNAME = nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; }; # this is the important part
  modules = [
	./configuration.nix
  ];
};
```
-----------------
`configuration.nix`
Include the `hyprland` cachix into you config file so that you can access pre-compiled binaries to save time when rebuilding your system. 
```
nix.settings.substituters = [
  ...
  "https://hyprland.cachix.org"
];
nix.settings.trusted-public-keys = [
  ...
  "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
]
```

If you're like me, you might be coming from some other desktop environment like GNOME. This was the hardest part to find information IMO. This is what I found works for me. That said, it's probably not the "ideal" or "correct" way to do it and there's probably a cleaner way.. but it's a learning process.

Enable hyprland and a couple other settings:
```
programs.hyprland = {
  enable = true;
  xwayland.enable = true;
};

programs.dconf.enable = true;
security.polkit.enable = true;

xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
```

Here's a couple environment variables. If you're using an Nvidia card, you'll want those last four too.
```
environment.sessionVariables = {
  # If your cursor becomes invisible
  WLR_NO_HARDWARE_CURSORS = "1";
  # Hint electron apps to use wayland
  NIXOS_OZONE_WL = "1";
  # Nvidia things...
  LIBVA_DRIVER_NAME = "nvidia";
  XDG_SESSION_TYPE = "wayland";
  GBM_BACKEND = "nvidia-drm";
  __GLX_VENDOR_LIBRARAY_NAME = "nvidia";
}
```

The last change I had to make here was to **turn off GNOME or other desktop env**. Initially, I didn't do this, so when I tried kicking off `Hyprland`, it would error out because it couldn't get access to the appropriate resources (something to do with `systemd` and seat management...). This involved settings `services.xserver.enable = false;` and turning off any other GNOME settings.

-----------------------
Home manager.

At this point, (again if you're like me) then you'll have no desktop and will be running directly through a `tty` session. With luck, the `Hyprland` command should work and boot up. Now it's a matter of setting things up though home-manager. 

When you ran the `Hyprland` command, a configuration file should have been made somewhere like `~./config/hypr/hyperland.conf`. To handle things through home-manager, I decided to move the configuration into my `/etc/nixos/` directory:
```
/etc/nixos/home-manager/
├── core.nix
├── programs
│   ├── apps.nix
│   ├── browsers.nix
│   ├── common.nix
│   ├── config
│   │   ├── hyprland.conf
│   │   └── start.sh
│   ├── default.nix
│   └── desktop.nix
└── shell
    ├── common.nix
    ├── default.nix
    └── terminals.nix
```
You'll notice another config file `start.sh`. This is run when hyprland starts up. Now that your config is in place, you're ready to set tell home-manager to handle your hyprland preferences. Inside of `programs/desktop.nix` (loaded through `programs/defaults.nix`), set the following:
```
{config, pkgs, ... }: 
{
  home.packages = with pkgs; [
    wofi
    dolphin
    hyprpaper
    # any other packages you'll want here
  ];
  
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;

    extraConfig = ''
      ${builtins.readFile ./config/hyprland.conf}
    '';
  };
}
```
You might notice that the `enable = true;` and `xwayland.enable = true;` settings seem repeated from the system configuration file. For some reason I found that I needed both....

Anyways, at this point, you should be set up with the basic wayland config.