

# Nix - DigitalOcean Image (1)

```nix
## flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = inputs@{ self, nixpkgs, ... }:
    let
      mpyc-demo = (import ./nix/mpyc-demo.nix { inherit pkgs; dir = ./.; });
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      digitalOceanConfig = import ./nix/digitalocean/image.nix {
        inherit pkgs;
        extraPackages = [ mpyc-demo ];
      };
    in
    {
		packages.digitalOceanImage = (pkgs.nixos digitalOceanConfig).digitalOceanImage;
	};
}
```


