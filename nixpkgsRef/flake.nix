{
outputs=inputs@{...}:
let
settings = import ./settings.nix;
nixpkgs=(if ((settings.system.profile == "homelab") || (settings.system.profile == "worklab"))
             then
               inputs.nixpkgs-stable
             else
               inputs.nixpkgs-unstable);

in {inherit nixpkgs;}
# // {
#       inherit (nixpkgs) lib checks devShells legacyPackages nixosModules htmlDocs;
#     packages.${settings.system.system}.default = nixpkgs.legacyPackages.${settings.system.system}.hello;
#     }

#     //{
# lib = nixpkgs.outputs.lib;
# checks = nixpkgs.outputs.checks;
# devShells=nixpkgs.outputs.devShells;
# legacyPackages=nixpkgs.outputs.legacyPackages;
# nixosModules=nixpkgs.outputs.nixosModules;
# htmlDocs=nixpkgs.outputs.htmlDocs;
# }
;


inputs ={

    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";#"https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs-r2311.url = "nixpkgs/nixos-23.11";
    nixpkgs-r2211.url = "github:NixOS/nixpkgs/nixos-22.11";
  };
}
