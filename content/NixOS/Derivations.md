---
tags:
  - nix
date: 2026 January
---
I'm finally coming around to learning more about nix and how to package programs for my own personal use. Reading the nix pills is good! Some of the specifics are a bit outdated and don't touch on some "modern" features like flakes, but it covers fundamental concepts that are worth understanding.

One of the main purposes of the nix language is in the packaging process, and derivations are the building blocks to do so. Whenever you package something using nix, these derivations are used as a specification for the package and the contents are built on such specifications. The derivations and output content can be found in the nix store (usually `/nix/store`). You generally won't be writing derivations yourself, but rather use builtin utilities to create derivations. 
### What is a derivation?
It's a special kind of attribute set that needs particular elements in its definition. As an example, we can inspect the derivation specs for the item below. Within an interactive environment using `nix repl`, we can verify that the drv file contains an attribute set:
```nix
drv = import /nix/store/xsqhh6s0c3fa9va5gnk6mdifm7zqwvmh-bash52-037.drv
builtins.isAttrs drv #true
builtins.attrNames drv # [ "all" "drvPath" "name" "out" "outPath" "outputName" "type" ]

drv.name # "bash52-037"
drv.type # "derivation"
```

I'll note that nix knows to distinguish derivations from other, more generic, attribute sets by catching that `drv.type = "derivation"`. So in a very simplistic case, a derivation is just an attribute set with an attribute `type` that is set to `"derivation"`. The interesting bits come from creating a derivation that "works".
### Creating a derivation.
Nix has builtin utilities for creating functioning derivations that will compile and package software. The fact that `drv.type = "derivation"` only means that nix will treat the attribute set like a derivation. 

The [`derivation`](https://nix.dev/manual/nix/2.28/language/derivations) builtin function is one such utility, but there are others as well (e.g. `pkgs.mkShell`). 
$$
\texttt{derivation} :\{\texttt{d}\in \texttt{AttrSet}\ |\ \texttt{name, system, builder} \in \texttt{d}\} \rightarrow \texttt{Derivations}
$$
This function takes any attribute set with the `name`, `system`, and `builder` attributes well-defined and returns a derivation. The input can have other attributes as well, but the three listed ones are requirements.

Using the `derivation` function only produces an expression which can then be evaluated to build the specified package. You can use it to offload a lot of the boilerplate that you'd have to write otherwise. Once the derivation is defined (i.e., instantiated), it still needs to get built.
### Example
For illustrative purposes, it's worth running through an example. For a simple case, you can run `nix-build` on the example above. This produced a file at the new store path
`/nix/store/yp6bfms6q369y93j622mqq6i6b02xwbq-bash52-037`.
This turns out to be a patch report for bash-release 5.2. 

The output store path above turns out to be the same as `drv.outPath`. In particular, `drv.outPath` was already defined before we called `nix-build`. Nix knows how to compute the hash in the output store path(s) before anything is ever built!
### Building with `derivation`
What does `nix-build` do when it is called on an output of the `derivation` function? Recall that an input to `derivation` must have the form `a = { name = "x"; builder = "y"; system = "z"; ... }`. We can inspect the result using `builtins.attrNames` like before.
```nix
let
  pkgs = import <nixpkgs> { };
in
builtins.attrNames ( derivation {
  name = "example"; 
  builder = "${pkgs.bash}/bin/bash"; 
  system = builtins.currentSystem; 
  src = path-to-blah.tar.gz;
  args = [ ./setup.sh ];
  buildInputs = [
	inp1
	inp2
  ];
  ... 
} )

# [
#   "all"
#   "builder"
#   "drvAttrs"
#   "drvPath"
#   "name"
#   "out"
#   "outPath"
#   "outputName"
#   "system"
#   "type"
#   "args"
#   ...
# ]
```

I threw in some optional parameters `args`, `src`, and `builtInputs`; you can throw basically anything else into the derivation function. You can even include parameters which are themselves [functions which can be called to return other derivations](https://nixos.org/guides/nix-pills/14-override-design-pattern.html). When you call `nix-build` on this derivation, it runs `builder` using the arguments provided in `args` with environment variables corresponding to the attributes themselves.

So in this example, `nix-build` will essentially call `bash setup.sh` and the setup script will be able to access variables like `${src}` and `${buildInputs}`. 