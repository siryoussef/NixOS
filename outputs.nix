{inputs,self,...}:
let
      Settings = import ./settings.nix {inherit pkgs;};
      systemSettings = Settings.systemSettings;
      userSettings = Settings.userSettings;

      # create patched nixpkgs

#       nixpkgs=inputs.nixpkgsRef.nixpkgs; #{ inherit systemSettings;};
#       inputs= {inherit inputs;} // {nixpkgs=nixpkgs;};
      nixpkgs=(if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
             then
               inputs.nixpkgs-stable
             else
               inputs.nixpkgs-unstable);
      home-manager= (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
             then
               inputs.home-manager-stable
             else
               inputs.home-manager-unstable);
      nixpkgs-patched =
        (import inputs.nixpkgs { system = systemSettings.system; rocmSupport = (if systemSettings.gpu == "amd" then true else false); }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
          patches = [ ./patches/emacs-no-version-check.patch ];
        };

      # configure pkgs
      pkgs = import nixpkgs-patched {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = with inputs;[
          rust-overlay.overlays.default
          snowfall-flake.overlays.default
          ytdlp-gui.overlay
          ];
      };

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-r2311 = import inputs.nixpkgs-r2311 {
        system = systemSettings.system;
          config.allowUnfree = true;
      };

      pkgs-r2211 = import inputs.nixpkgs-r2211 {
        system = systemSettings.system;
          config.allowUnfree = true;
      };

      pkgs-emacs = import inputs.emacs-pin-nixpkgs {
        system = systemSettings.system;
      };

      pkgs-kdenlive = import inputs.kdenlive-pin-nixpkgs {
        system = systemSettings.system;
      };

      pkgs-nwg-dock-hyprland = import inputs.nwg-dock-hyprland-pin-nixpkgs {
        system = systemSettings.system;
      };


      # configure lib
      lib = nixpkgs.lib//inputs.NixVirt.lib;

      unifiedHome = {
        extraSpecialArgs = {
          inherit pkgs-stable;
          inherit pkgs-emacs;
          inherit pkgs-kdenlive;
          inherit pkgs-nwg-dock-hyprland;
          inherit systemSettings;
          inherit userSettings;
          inherit inputs;
          };
        modules =  (map (pkg: ( inputs.${pkg}.homeManagerModules.${pkg} ) ) ["nix-flatpak" "plasma-manager" ])
         ++ (with inputs;[impermanence.nixosModules.home-manager.impermanence
         NixVirt.homeModules.default])
         ++ [
#               inputs.plasma-manager.homeManagerModules.plasma-manager
#               inputs.nix-flatpak.homeManagerModules.nix-flatpak # Declarative flatpaks
          ];
        nixpkgs = [(./. + "/profiles" + ("/" + systemSettings.profile)
              + "/nixpkgs-options.nix")];

        path = (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/home.nix"); # load home.nix from selected PROFILE

        };/*./patches/emacs-no-version-check.patch*/
      # Systems that can run tests:
      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      # Function to generate a set based on supported systems:
      forAllSystems = lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor =
        forAllSystems (system: import nixpkgs-patched { inherit system; });

#       modules = [ ];
    in inputs.flake-parts.lib.mkFlake { inherit inputs; } rec{
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = supportedSystems;
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs-patched{inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };};

        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
#         packages.default = pkgs.hello;
#         devShell.default=import ./NixDevEnvs/shell.nix{inherit pkgs pkgs-stable;};
        packages =  {
            default = self.packages.${system}.install;
            install = pkgs.writeShellApplication {
              name = "install";
              runtimeInputs = with pkgs; [ git ]; # I could make this fancier by adding other deps
              text = ''${./install.sh} "$@"'';
            };
            flaky-os = inputs.wfvm.lib.makeWindowsImage { installCommands= with inputs.wfvm.lib.layers;[anaconda3 msys2]; };
            virtdeclare = inputs.NixVirt.packages.${system}.default;
            nh = inputs.nh.packages.${system}.default;
          };
        apps =  {
          default = self.apps.${system}.install;
          install = {
            type = "app";
            program = "${self.packages.${system}.install}/bin/install";
          };
          virtdeclare = inputs.NixVirt.apps.${system}.virtdeclare;
        };

      };
      flake = {
        devShells.${systemSettings.system}.default=import ./NixDevEnvs/shell.nix{inherit pkgs-stable;};
        systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
        modules = [
#           ./modules
        ];
        };

        homeConfigurations = {
        ${userSettings.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = unifiedHome.modules ++ [(unifiedHome.path)] ++ unifiedHome.nixpkgs;
          extraSpecialArgs = unifiedHome.extraSpecialArgs;
        }; };

        nixosConfigurations = import ./nixosConfigurations.nix{inherit systemSettings userSettings unifiedHome home-manager nixpkgs-patched lib inputs pkgs-stable;};

        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
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
# for any option to be defined outside the flake-parts function temporarily if the function is causing an error with it
    }
