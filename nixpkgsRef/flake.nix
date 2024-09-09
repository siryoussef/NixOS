{
outputs=inputs@{...}:
let
Settings = import ./settings.nix;
systemSettings = Settings.systemSettings;
nixpkgs=(if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
             then
               inputs.nixpkgs-stable
             else
               inputs.nixpkgs-unstable);

in {inherit nixpkgs;}
# // {
#       inherit (nixpkgs) lib checks devShells legacyPackages nixosModules htmlDocs;
#     packages.${systemSettings.system}.default = nixpkgs.legacyPackages.${systemSettings.system}.hello;
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
