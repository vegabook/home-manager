# this is to prevent chicken and egg. Just do this the first time on a new machine
# to get home manager running. 
#
# First make sure to add the hostname to the flake.nix in this directory !!

nix run home-manager/master -- switch --flake "$HOME/.config/home-manager#$(hostname -s)"

