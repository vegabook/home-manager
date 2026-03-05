#!/usr/bin/env bash
cd ~/.config/home-manager

# Detect platform and use appropriate flake configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  if [[ $(uname -m) == "arm64" ]]; then
    # Apple Silicon
    home-manager switch --flake .#tbrowne@aarch64-darwin
  else
    # Intel Mac
    home-manager switch --flake .#tbrowne@x86_64-darwin
  fi
else
  # Linux
  home-manager switch --flake .#tbrowne
fi
