---
date: 2025 March
tags:
  - nixos
---
A few times when reconfiguring and rebuilding my NixOS system, I've run into a partial log that contains the following. 
```
Please do one of the following:
- Move or remove the above files and try again.
- In standalone mode, use 'home-manager switch -b backup' to back up
  files automatically.
```
The issue is that the logs get cut off so that I can't see the bad files!!

You can use the following command to see the full logs:
```
# replace 'max' with your username
journalctl -e --unit home-manager-max.service
```