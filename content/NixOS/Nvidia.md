---
date: 2025 March
tags:
  - nixos
---
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia.open = true;
hardware.graphics.enable = true;
```
