{
  description = "git講習会 スライド";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) stdenv lib;
        html = stdenv.mkDerivation {
          pname = "git-lecture-slide";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = with pkgs; [ marp-cli ];
          buildPhase = ''
            mkdir -p out
            cp -R theme out/
            marp --theme theme/traP.css --allow-local-files -o out/index.html slide.md
          '';
          installPhase = ''
            mkdir -p $out
            mv out $out/slide
          '';
        };
      in
      {
        packages = {
          default = html;
          inherit html;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ marp-cli ];
        };
      }
    );
}
