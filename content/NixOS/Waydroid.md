---
draft: "true"
date: March 2025
---
Waydroid to emulate some android programs.
https://nixos.wiki/wiki/WayDroid

Getting waydroid itself is pretty straightforward and there's an [official page](- Follow [instructions](https://nixos.wiki/wiki/WayDroid) to set up waydroid) on the NixOS site. Once you set it up, you can apk files. However, these files probably won't run out of box... so you have to do some more work.

It's... kind of a pain to figure this one out and I have not yet resolved my issues. But here's some progress I've made, following along as in [here](https://www.reddit.com/r/NixOS/comments/15k2jxc/need_help_with_activating_libhoudini_for_waydroid/)
- Set up [[nur]] and install the `nur.repos.ataraxiasjel.waydroid-script` package
- Rebuild and find where the `waydroid-script` script was placed. I found mine in `/nix/store/yg9llnrrs4dn1a09mmbm4bkvkw8k6zw3-waydroid-script-0-unstable-2024-01-20/bin`
- Run the script as below. You can also add `magisk`, but I was having an issue with the install...
```
sudo waydroid-script install gapps magisk libhoudini widevine
```
- [Add a google play certification](https://docs.waydro.id/faq/google-play-certification). Without this, you won't be able to run any GApps. This basically adds the virtual device to your google account.
From here, you should be able to install the apk file and it will be visible when you boot up the waydroid UI with `waydroid show-full-ui`.

TODO
Waydroid... libhoudini: see the following links
https://www.reddit.com/r/waydroid/comments/1bjnurq/how_to_install_apps_on_waydroid/
https://www.reddit.com/r/NixOS/comments/15k2jxc/need_help_with_activating_libhoudini_for_waydroid/

follow this for NUR, include `@imports`
https://haseebmajid.dev/posts/2023-06-22-til-use-nur-with-home-manager-flake/

https://github.com/casualsnek/waydroid_script/pull/161