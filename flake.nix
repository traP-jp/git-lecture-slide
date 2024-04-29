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
            cp -R assets out/
            cp -R theme out/
            marp --theme theme/traP.css --allow-local-files -o out/index.html slide.md
          '';
          installPhase = ''
            mkdir -p $out
            mv out $out/slide
          '';
        };
        pdf = stdenv.mkDerivation {
          pname = "git-lecture-slide-pdf";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = with pkgs; [
            marp-cli
            ungoogled-chromium
            fontconfig
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-color-emoji
          ];
          buildPhase = ''
            # https://github.com/NixOS/nix/issues/670
            export HOME="$(pwd)"
            marp --theme theme/traP.css --allow-local-files -o slide.pdf slide.md
            chmod 644 slide.pdf
          '';
          installPhase = ''
            mkdir -p $out
            mv slide.pdf $out/slide.pdf
          '';
          CHROME_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
          FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
        };
      in
      {
        packages = {
          default = html;
          inherit html pdf;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ marp-cli ];
        };
      }
    );
}
