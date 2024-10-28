let
settings = import ./settings.nix;
nixpkgs=(if ((settings.system.profile == "homelab") || (settings.system.profile == "worklab"))
             then
               builtins.getFlake "nixpkgs/nixos-24.05"
             else
               builtins.getFlake "nixpkgs/nixos-unstable");
lib=nixpkgs.lib;

in nixpkgs {inherit lib;}
