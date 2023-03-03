

# Nix - MPyC Package

``` Nix
{ pkgs, dir }:
(pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python3;
    projectDir = dir;
    extraPackages = (ps: [(pkgs.python3Packages.buildPythonPackage {
	      name = "mpyc";
          src = dir;
	    })]);
    overrides = pkgs.poetry2nix.overrides.withDefaults (
      self: super: {
        gmpy2 = pkgs.python3Packages.gmpy2;
      }
    );
  })
```


