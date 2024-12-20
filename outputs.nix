{inputs, self,...}:
let
      settings = import ./settings.nix {inherit self inputs pkgs';};
#       Storage = import settings.paths.storage{inherit settings config;};
      # create patched nixpkgs

#       nixpkgs=inputs.nixpkgsRef.nixpkgs; #{ inherit settings;};
#       inputs= {inherit inputs;} // {nixpkgs=nixpkgs;};
      nixpkgs=(if ((settings.system.profile == "homelab") || (settings.system.profile == "worklab"))
             then
               inputs.nixpkgs-stable
             else
               inputs.nixpkgs-unstable);
      home-manager= (if ((settings.system.profile == "homelab") || (settings.system.profile == "worklab"))
             then
               inputs.home-manager-stable
             else
               inputs.home-manager-unstable);
      nixpkgs-patched =
        (import inputs.nixpkgs { system = settings.system.arch; rocmSupport = (if settings.system.gpu == "amd" then true else false); }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
          patches =if inputs.nixpkgs == inputs.nixpkgs-unstable then [  ./patches/emacs-no-version-check.patch ] else [./patches/emacs-no-version-check-nixpkgs-stable24.05.patch];
        };

      # configure pkgs
      nix-pkgs-options= import ./nix-pkgs-options/common.nix {inherit pkgs' lib inputs;}; 
      overlays = nix-pkgs-options.nixpkgs.overlays;
      config = nix-pkgs-options.nixpkgs.config;
      pkgs = import nixpkgs-patched {
        system = settings.system.arch;
        inherit overlays config;
      };

      pkgs-stable = import inputs.nixpkgs-stable {
        system = settings.system.arch;
        inherit overlays config;
      };

      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = settings.system.arch;
        inherit overlays config;
      };

      pkgs-r2311 = import inputs.nixpkgs-r2311 {
        system = settings.system.arch;
        inherit overlays config;
      };

      pkgs-r2211 = import inputs.nixpkgs-r2211 {
        system = settings.system.arch;
        inherit overlays config;
      };

      pkgs-emacs = import inputs.emacs-pin-nixpkgs {
        system = settings.system.arch;
      };

      pkgs-kdenlive = import inputs.kdenlive-pin-nixpkgs {
        system = settings.system.arch;
      };

      pkgs-nwg-dock-hyprland = import inputs.nwg-dock-hyprland-pin-nixpkgs {
        system = settings.system.arch;
      };

      pkgs'={
        main=pkgs;
        stable= pkgs-stable;
        unstable=pkgs-unstable;
        r2311=pkgs-r2311;
        r2211=pkgs-r2211;
        emacs=pkgs-emacs;
        kdenlive=pkgs-kdenlive.kdenlive;
        nwg-dock-hyprland=pkgs-nwg-dock-hyprland;
      };


      # configure lib
      lib = nixpkgs.lib//inputs.NixVirt.lib;
      android-sdk= {lib, pkgs',...}: let pkgs=pkgs'.main; in rec{
              # inherit lib;
              android-sdk= { enable = true;
                # path = "${config.home.homeDirectory}/.android/sdk"; # Optional; default path is "~/.local/share/android".
                packages = settings.pkglists.android-sdk-34;
              };
          };
      specialArgs ={
          inherit pkgs' settings inputs;
          inherit pkgs;
          };
      unifiedHome = {
        extraSpecialArgs = specialArgs;
        modules =  (map (pkg: ( inputs.${pkg}.homeManagerModules.${pkg} ) ) [
          # "nix-flatpak"
          "plasma-manager" 
          ])++(map (pkg: (pkg.homeManagerModules.default))(with inputs;[
            chaotic
            declarative-flatpak
          ]))++ (with inputs;[
            impermanence.nixosModules.home-manager.impermanence
            NixVirt.homeModules.default 
            android-nixpkgs.hmModule
            ])++ [
          # android-sdk 
          ];
        nixpkgs = [(./nix-pkgs-options/home.nix)];
#         [(./. + "/profiles" + ("/" + settings.system.profile)+ "/nixpkgs-options.nix")];

        path = (./. + "/profiles" + ("/" + settings.system.profile)
              + "/home.nix"); # load home.nix from selected PROFILE

        };/*./patches/emacs-no-version-check.patch*/
      # Systems that can run tests:
      # supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      supportedSystems = import inputs.systems;
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
            android-sdk = inputs.android-nixpkgs.sdk.${system} (settings.pkglists.android-sdk-34);
            # voila = inputs.dream2nix.lib.evalModules {
            #   packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
            #   modules = [
            #     # Import our actual package definiton as a dream2nix module from ./default.nix
            #     ./voila.nix
            #     {
            #       # Aid dream2nix to find the project root. This setup should also works for mono
            #       # repos. If you only have a single project, the defaults should be good enough.
            #       paths.projectRoot = ./.;
            #       # can be changed to ".git" or "flake.nix" to get rid of .project-root
            #       paths.projectRootFile = "flake.nix";
            #       paths.package = ./.;
            #     }
            #   ];
            # };
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
        systemConfigs.default =  inputs.system-manager.lib.makeSystemConfig {
        modules =  [
          ({config,...}:import ./manager{inherit settings lib pkgs config ;})
        ];
        };
        devShells.${settings.system.arch}.default=settings.pkglists.shells.NixDevEnv;
#         import ./NixDevEnvs/shell.nix{inherit pkgs-stable pkgs ;};
        homeConfigurations = {
        root = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = unifiedHome.modules ++ [(./manager/rootHome.nix)] ++ unifiedHome.nixpkgs;
          extraSpecialArgs = unifiedHome.extraSpecialArgs;
        };
        ${settings.user.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = unifiedHome.modules ++ [(unifiedHome.path)] ++ unifiedHome.nixpkgs;
          extraSpecialArgs = unifiedHome.extraSpecialArgs;
        }; };

        nixosConfigurations = import ./nixosConfigurations.nix{inherit settings unifiedHome home-manager nixpkgs-patched lib inputs pkgs' pkgs;};

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
