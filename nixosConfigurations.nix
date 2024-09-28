{systemSettings,userSettings,unifiedHome,home-manager,nixpkgs-patched,lib,inputs,pkgs-stable,...}:{
        ${systemSettings.hostname} = lib.nixosSystem {
#           system = systemSettings.system;
          modules = [ home-manager.nixosModules.home-manager
             inputs.qnr.nixosModules.local-registry
             ]
          ++ (map (pkg: inputs.${pkg}.nixosModules.${pkg} ) ["impermanence" "nix-flatpak" "nix-data" ])
          ++ (map(x: with x; (nixosModules.default)) (with inputs; [agenix NixVirt lix-module ]))
            ++
            [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")

            ({ pkgs, config, ... }:
              let
                nur-no-pkgs = import inputs.nur {
                  nurpkgs = import nixpkgs-patched { system = systemSettings.system; };
                };
              in {
                nixpkgs.overlays = with inputs;[nur.overlay ];
                imports = [ nur-no-pkgs.repos.iopq.modules.xraya  ];
                services.xraya.enable = true;
                environment.systemPackages = (map (pkg: (with pkg;(packages.${systemSettings.system}.default)))  (with inputs;[
                fh
                agenix
                snowfall-flake
                nixos-conf-editor
#                 snow
#                 nix-software-center
#                 thorium-browser
                zen-browser
                NixVirt
                ]))
                ++ [pkgs.nur.repos.ataraxiasjel.waydroid-script ]
                ++ (map (pkg : pkg.defaultPackage.${systemSettings.system}) (with inputs; [thorium-browser] ))
                ;
              home-manager= rec{
                users.${userSettings.username} = import unifiedHome.path; #import ./users/default/home.nix;
                extraSpecialArgs = unifiedHome.extraSpecialArgs;
                sharedModules = (if useGlobalPkgs == false then unifiedHome.modules++unifiedHome.nixpkgs else unifiedHome.modules);
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
              };
                programs={ nh={flake= ./.; /*package=perSystem.packages.nh;*/};
                  fuse.userAllowOther = true;
                  nix-data = {
                    systemconfig =  (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix");
                    flake = "/etc/nixos/flake.nix";
                    flakearg = systemSettings.hostname;
                  };
                };
                  snowflakeos.gnome.enable = false;
                #   snowflakeos.osInfo.enable = true;
                nix.localRegistry={
                  enable = true;# Enable quick-nix-registry
                  cacheGlobalRegistry = true;# Cache the default nix registry locally, to avoid extraneous registry updates from nix cli.
                  noGlobalRegistry = false;}; # Set an empty global registry.
                })


          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };

        };
        }
