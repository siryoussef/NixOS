 # shell.nix
{pkgs-stable ? import <nixpkgs>{},settings ? let pkgs = pkgs-stable; pkgs-kdenlive=pkgs-kdenlive; inputs=let flake=import ../flake.nix; in flake.inputs; in import ../settings.nix{inherit pkgs pkgs-stable pkgs-kdenlive inputs;},...}:
settings.pkglists.shells.NixDevEnv

