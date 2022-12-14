
\begin{frame}

\frametitle{Nix - Basic flake.nix}

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
		myHello = pkgs.hello;
	};
}
```

\end{frame}

