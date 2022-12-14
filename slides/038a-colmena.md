
\begin{frame}

\frametitle{Colmena}

``` nix
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
  packages.colmena = {
	meta = {
	  nixpkgs = pkgs;
	};
	defaults = digitalOceanConfig;
  } // builtins.fromJSON (builtins.readFile ./hosts.json);
};
```

\end{frame}

