{settings, unifiedHome, home-manager, nixpkgs-patched, lib, inputs, pkgs-stable, pkgs',...}:{
        ${settings.system.hostname} = lib.nixosSystem {
#           system = settings.system.arch;
          modules = (map (pkg: inputs.${pkg}.nixosModules.${pkg} ) [
          "impermanence"
          "nix-flatpak"
          "nix-data"
          ])++(map(x: with x; (nixosModules.default)) (with inputs; [
          agenix
          NixVirt
          lix-module
          chaotic
          ]))++[
          home-manager.nixosModules.home-manager
          inputs.qnr.nixosModules.local-registry
          (./. + "/profiles" + ("/" + settings.system.profile)+ "/configuration.nix")({ pkgs, config, ... }:
              let
                nur-no-pkgs = import inputs.nur {
                  nurpkgs = import nixpkgs-patched { system = settings.system.arch; };
                };
              in {
#                 nixpkgs={overlays = with inputs;[nur.overlay  ];};
                imports = [
                  nur-no-pkgs.repos.iopq.modules.xraya
#                   (import ./nixCommon.nix{inherit pkgs config;})
                  ./nix-pkgs-options/system.nix
                  ];
                services.xraya.enable = false;
                environment.systemPackages = settings.pkglists.system ++
                [pkgs'.stable.nur.repos.ataraxiasjel.waydroid-script];
              home-manager= rec{
                users.root={
                  imports=[
#                     ./user/app/virtualization/virtualization.nix
                    ./manager/rootHome.nix
                    ];
                };
                users.${settings.user.username} = import unifiedHome.path; #import ./users/default/home.nix;
                extraSpecialArgs = unifiedHome.extraSpecialArgs;
                sharedModules = (if useGlobalPkgs == true then unifiedHome.modules else unifiedHome.modules++unifiedHome.nixpkgs );
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                verbose=false;
              };
                programs={ nh={flake= ./.; /*package=perSystem.packages.nh;*/};
                  fuse.userAllowOther = true;
                  nix-data = {
                    systemconfig =  (./. + "/profiles" + ("/" + settings.system.profile) + "/configuration.nix");
                    flake = "/etc/nixos/flake.nix";
                    flakearg = settings.system.hostname;
                  };
                };
#                   snowflakeos.gnome.enable = false;
                #   snowflakeos.osInfo.enable = true;
                nix.localRegistry={
                  enable = true;# Enable quick-nix-registry
                  cacheGlobalRegistry = true;# Cache the default nix registry locally, to avoid extraneous registry updates from nix cli.
                  noGlobalRegistry = false;}; # Set an empty global registry.
                }
            )
          ]; # load configuration.nix from selected PROFILE
          specialArgs = {
            # pass config variables from above
            inherit pkgs';
            inherit pkgs-stable;
            inherit settings;
            inherit inputs;
          };
        };
        }
