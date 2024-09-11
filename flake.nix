{description = "Flake of Snowyfrank";

  outputs = inputs@{ self,...}:

    let
      Settings = import ./settings.nix;
      systemSettings = Settings.systemSettings;
      userSettings = Settings.userSettings;

      # create patched nixpkgs

      nixpkgsOutput= inputs.nixpkgsRef.nixpkgs;
      home-manager= (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
             then
               inputs.home-manager-stable
             else
               inputs.home-manager-unstable);
      nixpkgs-patched =
        (import nixpkgsOutput { system = systemSettings.system; rocmSupport = (if systemSettings.gpu == "amd" then true else false);}).applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgsOutput;
          patches = [ ./patches/emacs-no-version-check.patch ];
        };

      # configure pkgs
      pkgs = import nixpkgs-patched {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [
          inputs.rust-overlay.overlays.default
          inputs.ytdlp-gui.overlay
          inputs.snowfall-flake.overlays.default
          ];
      };

      pkgs-stable = import inputs.nixpkgsRef.inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-r2311 = import inputs.nixpkgsRef.inputs.nixpkgs-r2311 {
        system = systemSettings.system;
          config.allowUnfree = true;
      };

      pkgs-r2211 = import inputs.nixpkgsRef.inputs.nixpkgs-r2211 {
        system = systemSettings.system;
          config.allowUnfree = true;
      };

      pkgs-emacs = import inputs.emacs-pin-nixpkgs {
        system = systemSettings.system;
      };

      pkgs-kdenlive = import inputs.kdenlive-pin-nixpkgs {
        system = systemSettings.system;
      };



      # configure lib
      lib = nixpkgsOutput.lib;

      unifiedHome = {
        extraSpecialArgs = {
          inherit pkgs-stable;
          inherit pkgs-emacs;
          inherit pkgs-kdenlive;
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
          };
        modules =  (map (pkg: ( inputs.${pkg}.homeManagerModules.${pkg} ) ) ["nix-flatpak" "plasma-manager" "impermanence"])
         ++/* [inputs.impermanence.nixosModules.home-manager.impermanence] ++ */[
#               inputs.plasma-manager.homeManagerModules.plasma-manager
#               inputs.nix-flatpak.homeManagerModules.nix-flatpak # Declarative flatpaks
          ];
        nixpkgs = [(./. + "/profiles" + ("/" + systemSettings.profile)
              + "/nixpkgs-options.nix")];

        path = (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/home.nix"); # load home.nix from selected PROFILE

        };
      # Systems that can run tests:
      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = nixpkgsOutput.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor =
        forAllSystems (system: import nixpkgs-patched { inherit system; });

#       modules = [ ];
    in (inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {



        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
#         packages.default = pkgs.hello;
      };
      flake = {
        homeConfigurations = {
        ${userSettings.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = unifiedHome.modules ++ [(unifiedHome.path)] ++ unifiedHome.nixpkgs;
          extraSpecialArgs = unifiedHome.extraSpecialArgs;
        }; };


        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
        modules = [
#           ./modules
        ];
      };
      };

#       outputs.pkgSettings = import ./pkgs.nix ;
#       outputs = inputs : inputs.snowfall-lib.mkFlake {
#             inherit inputs;
#             src = ./.;
#
#             overlays =  with inputs;[
#             # To make this flake's packages available in your NixPkgs package set.
#               snowfall-flake.overlay
#               snowfall-thaw.overlays
#               snowfall-dotbox.overlays
#           ]; };







    }//{
    packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ]; # I could make this fancier by adding other deps
            text = ''${./install.sh} "$@"'';
          };
        });

    apps = forAllSystems (system: {
          default = self.apps.${system}.install;

          install = {
            type = "app";
            program = "${self.packages.${system}.install}/bin/install";
          };
        });

    nixosConfigurations = {
        ${systemSettings.hostname} = lib.nixosSystem {
#           system = systemSettings.system;
          modules = [ home-manager.nixosModules.home-manager
             {home-manager= rec{
                users.${userSettings.username} = import unifiedHome.path; #import ./users/default/home.nix;
                extraSpecialArgs = unifiedHome.extraSpecialArgs;
                sharedModules = (if useGlobalPkgs == false then unifiedHome.modules++unifiedHome.nixpkgs else unifiedHome.modules);
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
              };
            }
            ] ++
            (map (pkg: inputs.${pkg}.nixosModules.${pkg} ) ["impermanence" "nix-flatpak" "nix-data" /*"home-manager"*/])
          ++
             (map(x: with x; (nixosModules.default)) (with inputs; [agenix NixVirt lix-module /*home-manager*/]))
            ++
            [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")

            { nixpkgs.overlays = with inputs;[nur.overlay ]; }
            ({ pkgs, config, ... }:
              let
                nur-no-pkgs = import inputs.nur {
                  nurpkgs = import nixpkgs-patched { system = systemSettings.system; };
                };
              in {
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
                ]))
                ++ [pkgs.nur.repos.ataraxiasjel.waydroid-script ]
                ++ (map (pkg : pkg.defaultPackage.${systemSettings.system}) (with inputs; [thorium-browser] ));
                programs.nix-data = {
                  systemconfig =  (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix");
                  flake = "/etc/nixos/flake.nix";
                  flakearg = systemSettings.hostname;
                };
                #   snowflakeos.gnome.enable = false;
                #   snowflakeos.osInfo.enable = true;
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
        };

    });

  inputs ={

    flake-parts.url = "github:hercules-ci/flake-parts";
#       nixpkgs= builtins.getFlake Settings.nixpkgs;
#       home-manager.url = ("git+path:///etc/nixos/settings.nix").home-manager;

#     nixpkgs={url = "path:///etc/nixos/testing/nixpkgsRef/default.nix"; flake=false;};
    nixpkgsRef={url = "path:///etc/nixos/nixpkgsRef";};

    nixpkgs-python.url = "https://flakehub.com/f/cachix/nixpkgs-python/1.2.0.tar.gz";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
    };
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    nur.url = "github:nix-community/NUR";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    snowfall-lib = {
      url = "https://flakehub.com/f/snowfallorg/lib/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable"; };
    snowfall-flake = {
      url = "https://flakehub.com/f/snowfallorg/flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable" ;};
    snowfall-thaw = {
      url = "https://flakehub.com/f/snowfallorg/thaw/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
        };
    snowfall-dotbox = {
      url = "https://flakehub.com/f/snowfallorg/dotbox/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
		};
    snowflakeos.url = "github:siryoussef/snowflakeos-modules";
    snowflakeos-module-manager = {
      url = "github:snowfallorg/snowflakeos-module-manager";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
      };
    nix-data={url = "github:snowfallorg/nix-data";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable" ;};
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nixos-conf-editor.url = "github:vlinkz/nixos-conf-editor";
    snow.url = "github:snowflakelinux/snow";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    fleek.url = "https://flakehub.com/f/ublue-os/fleek/0.10.5.tar.gz";
    blincus.url = "https://flakehub.com/f/ublue-os/blincus/0.3.2.tar.gz";

    disko.url = "https://flakehub.com/f/nix-community/disko/1.3.0.tar.gz";
    vscode.url = "https://flakehub.com/f/catppuccin/vscode/3.11.1.tar.gz";
    ytdlp-gui.url = "https://flakehub.com/f/BKSalman/ytdlp-gui/1.0.1.tar.gz";
    NixVirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs={
        nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
#         home-manager.follows = "home-manager-unstable";
        };
      };
    nix-gui={url = "github:nix-gui/nix-gui";};
    compat.url = "github:balsoft/nixos-fhs-compat";
    #plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";#"github:mcdonc/plasma-manager/enable-look-and-feel-settings";
      inputs={
        nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
        home-manager.follows = "home-manager-unstable";
        };
      };
    kwin-effects-forceblur={ url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";};

    scientific-fhs.url = "github:olynch/scientific-fhs";

    emacs-pin-nixpkgs.url = "nixpkgs/f8e2ebd66d097614d51a56a755450d4ae1632df1";
    kdenlive-pin-nixpkgs.url = "nixpkgs/cfec6d9203a461d9d698d8a60ef003cac6d0da94";

    home-manager-unstable = {url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";};

    home-manager-stable= {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-stable";};

    nix-doom-emacs = { url = "github:nix-community/nix-doom-emacs";
      inputs={nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
        nix-straight.follows = "nix-straight"; }; };

    nix-straight={url = "github:librephoenix/nix-straight.el/pgtk-patch";
      flake = false;};
    eaf = {url = "github:emacs-eaf/emacs-application-framework";flake = false;};
    eaf-browser = {url = "github:emacs-eaf/eaf-browser"; flake = false;};
    org-nursery = {url = "github:chrisbarrett/nursery"; flake = false;};
    org-yaap = {url = "gitlab:tygrdev/org-yaap"; flake = false;};
    org-side-tree = {url = "github:localauthor/org-side-tree"; flake = false;};
    org-timeblock = {url = "github:ichernyshovvv/org-timeblock";flake = false;};
    phscroll = {url = "github:misohena/phscroll"; flake = false;};

    stylix.url = "github:danth/stylix";

    rust-overlay.url = "github:oxalica/rust-overlay";

    blocklist-hosts = {url = "github:StevenBlack/hosts"; flake = false;};

    hyprland-plugins = {url = "github:hyprwm/hyprland-plugins"; flake = false;};
    thorium-browser.url = #"github:siryoussef/nix-thorium";
#     "git+https://codeberg.org/Tomkoid/thorium-browser-nix";
      "git+file:///Shared/@Repo/thorium-browser-nix/";
    agenix={
      url = "github:ryantm/agenix";
      # optional, not necessary for the module
      inputs.nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
      };
    quickgui={
      url = "https://flakehub.com/f/quickemu-project/quickgui/1.2.10.tar.gz";
      inputs.nixpkgs.follows="nixpkgsRef/nixpkgs-unstable";
      };
    impermanence.url = /*"git+file:///Shared/@Repo/impermanence/";*/ "github:siryoussef/impermanence";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs={
        nixpkgs.follows = "nixpkgsRef/nixpkgs-unstable";
#         nixpkgs-stable.follows = "nixpkgsRef/nixpkgs-stable";
        };
    };
  };
  }
