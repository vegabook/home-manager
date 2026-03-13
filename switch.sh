#!/usr/bin/env bash
cd ~/.config/home-manager

home-manager switch --flake ".#$(hostname)"
