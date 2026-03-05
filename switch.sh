#!/usr/bin/env bash
cd ~/.config/home-manager

# Detect the current system
SYSTEM=$(nix eval --impure --raw --expr 'builtins.currentSystem')

home-manager switch --flake ".#tbrowne@${SYSTEM}"
