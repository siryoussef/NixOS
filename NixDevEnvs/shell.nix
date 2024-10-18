 # shell.nix
{pkgs-stable ? import <nixpkgs>{},settings ? let pkgs = pkgs-stable; pkgs-kdenlive=pkgs-kdenlive; in import ../settings.nix{inherit pkgs pkgs-stable pkgs-kdenlive;},...}:
settings.pkglists.shells.NixDevEnv

