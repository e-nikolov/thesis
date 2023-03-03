

# Nix - RaspberryPi Image

```nix
let
  mpyc-demo = (import ./nix/mpyc-demo.nix { inherit pkgs; dir = ./.; });

  pkgs = import nixpkgs {
	system = "aarch64-linux";
  };
in
{
	packages.raspberryPi4Image = (pkgs.nixos ({ config, ... }: {
		system.stateVersion = "22.11";
		imports = [
		  ("${pkgs.path}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix")
		];
		
		environment.systemPackages = [
			mpyc-demo
		];
	})).sdImage;
};
```

