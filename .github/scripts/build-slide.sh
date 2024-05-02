#!/usr/bin/env bash

set -o pipefail
set -eux

nix build .#html
cp -r result/slide ./slide
sudo chown -R "$USER:$USER" slide
sudo chmod 755 slide

nix build .#pdf
cp result/slide.pdf ./slide/slide.pdf
sudo chown "$USER:$USER" slide/slide.pdf
