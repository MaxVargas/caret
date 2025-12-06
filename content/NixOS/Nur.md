---
date: 2025 March
---
Nixpkgs has plenty of stuff... but it's not everything. In particular, lots of people have developed useful packages which haven't made their way onto nixpkgs yet (for various possible reasons). You can import nur to access these extras. Inside of `nixos/configuration.nix`, you can add 
```nix
nix.nur.url = "github:nix-community/NUR";
``` 
into the inputs. Then you can import it through home manager, for example with the following in `home.nix`
```nix
{ pkgs, ... }@inputs: {
  imports = [
    inputs.nur.module.homeManager.default
  ]

  home.packages = with pkgs; [
    nur.repos.blah.blah
  ];
}
```
