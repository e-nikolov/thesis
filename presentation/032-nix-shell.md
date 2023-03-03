

# Nix - Development Shell

  ```nix

    devShell.x86_64-linux = pkgs.mkShell {
      shellHook = ''
        export PYTHONPATH=./
      '';
      
      nativeBuildInputs = [
        pkgs.curl pkgs.jq
        pkgs.colmena pkgs.pssh
        (pkgs.terraform.withPlugins
          (tp: [
            tp.digitalocean tp.null
            tp.external tp.tailscale
            tp.random
          ]))
        mpyc-demo
      ];
    };

  ```

