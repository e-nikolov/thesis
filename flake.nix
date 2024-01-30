{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv/python-rewrite";
    pandoc-crossref.url = "github:lierdakil/pandoc-crossref";
  };

  nixConfig = {
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://pandoc-crossref.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "pandoc-crossref.cachix.org-1:LI9ABFTkGpPCTkUTzoopVSSpb1a26RSTJNMsqVbDtPM="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    devShells = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          {
            # https://devenv.sh/reference/options/
            packages = [
              inputs.pandoc-crossref.packages.${system}.default
              pkgs.haskellPackages.pandoc
              # pkgs.haskellPackages.pandoc-crossref
              pkgs.pandoc
              pkgs.inkscape
              pkgs.python310Packages.pygments
            ];

            languages.texlive.enable = true;
            languages.texlive.packages = ["scheme-full"];
            dotenv.enable = true;

            enterShell = ''
            '';
          }
        ];
      };
    });
  };
}
