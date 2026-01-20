---
date: 2025 March
tags:
  - nix
  - nixos
---
Here begins some notes on my journey to swap my personal computing resources from Windows to NixOS.

Why: There's lots of reasons... I would have liked to do this sooner (March 2024) but that's okay. The internet has plenty of selling points as to why one would want to use NixOS over other operating systems such as the open-source community, declaratively configuring your system, etc etc. I was finding it an increasing pain to continue using windows...

How: I'm still learning how to better (best is a far dream haha) set up my system, but I'll outline my simple way to go about it over here.
- [[Hardware]]. Format your drives and get a bootable ISO
- [[Starter Config]]. Make things usable. A basic setup with flakes and home-manager.
- [[Games]].
- [[Nvidia]].
- [[Wayland]] and [[Desktop Environment]]s.
- A basic [[Shell]].
- A basic [[Flakes (Example)]].
- Some [[Error]] chasing.
- [[Mounting drives]] (usb, etc)

Resources: There's a couple of particularly useful resources that others have put together to help on the Nix journey. The main ones I've been using are:
- [NixOS & Flakes Book by Ryan Yin](https://nixos-and-flakes.thiscute.world/) is useful for a modernized(?) view on configuration with Flakes and Home-Manager.
- [Wil T's](https://www.youtube.com/@wilfridtaylor) YouTube channel, I found his [Installation Guide](https://www.youtube.com/watch?v=axOxLJ4BWmY&t=1197s) to be particularly educational, although the NixOS boot ISO walks you through a GUI installation nowadays.
- [The NixOS Manual](file:///nix/store/1gcwpwfkyscklraaxg3rw9vxdf5glfps-nixos-manual-html/share/doc/nixos/index.html). Eat your vegetables!
- [Nix Pills](https://nixos.org/guides/nix-pills/) More veggies...