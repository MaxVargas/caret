---
date: 2026 January
tags:
  - linux
  - nixos
---
Ok I kinda got rmpc (terminal-based music player client) working with youtube downloads. [This  link](https://ubuntuhandbook.org/index.php/2025/07/install-mpd-ubuntu/) was quite useful in debugging my mistakes, with the full nix config [here](https://github.com/MaxVargas/nixos-config). You'll be able to find how I handle rmpc, mpd, and any other dependencies, see the [rmpc yt docs](https://rmpc.mierak.dev/next/guides/youtube/) for more.

It's not 100% smooth, but it works. To add a song from youtube, run the command
```bash
rpmc addyt <link>
```
With my setup, it'll successfully download but then MPD, the music player daemon, will bug out and say the file doesn't exist. Within rmpc, you can `rescan` and the song should be visible and playable now.