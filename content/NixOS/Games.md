---
date: 2025 March
---
This part I got from Vimjoyer's video on the topic. Setting up steam starts with the following in the configuration file:

```
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

You also want to install `protonup` and when using home-manager, set
```
home.sessionvariables = {
  STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
    "\${HOME}/.steam/root/compatibilitytools.d"
}
```
Then you should be set up to run games on steam. 