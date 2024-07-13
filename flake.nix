{
  description = "Flake of Snowyfrank";

  outputs = inputs@{ self,...}:

    let

      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "Snowyfrank"; # hostname
        profile = "work"; # select a profile defined from my profiles directory
        timezone = "Africa/Cairo"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        bootMode = "uefi"; # uefi or bios
        bootMountPath = "/boot/efi"; # mount path for efi boot partition; only used for uefi boot mode
        grubDevice = "/dev/disk/by-label/Boot"; # device identifier for grub; only used for legacy (bios) boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "youssef"; # username
        name = "Youssef"; # name/identifier
        email = "youssef@disroot.org"; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        theme = "uwunicorn-yt"; # selcted theme from my themes directory (./themes/)
        wm = "plasma"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
        # window manager type (hyprland or x11) translator
        wmType = if (wm == "hyprland") || (wm == "plasma") then "wayland" else "x11";
        browser = "floorp"; # Default browser; must select one from ./user/app/browser/
        defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
        term = "konsole"; # Default terminal command;
        font = "Intel One Mono"; # Selected font
        fontPkg = pkgs.intel-one-mono; # Font package
        editor =  "kate";  #"emacsclient"; # Default editor;
        # editor spawning translator
        # generates a command that can be used to spawn editor inside a gui
        # EDITOR and TERM session variables must be set in home.nix or other module
        # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
        spawnEditor = if (editor == "emacsclient") then
                        "emacsclient -c -a 'emacs'"
                      else
                        (if ((editor == "vim") ||
                             (editor == "nvim") ||
                             (editor == "nano")) then
                               "exec " + term + " -e " + editor
                         else
                           editor);
      };

      # create patched nixpkgs
      nixpkgs-patched =
        (import inputs.nixpkgs { system = systemSettings.system; }).applyPatches {
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
        overlays = [
          inputs.rust-overlay.overlays.default
          inputs.ytdlp-gui.overlay
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



      # configure lib
      lib = inputs.nixpkgs.lib;
      home-manager = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "worklab"))
             then
               inputs.home-manager-stable
             else
               inputs.home-manager-unstable);
      # Systems that can run tests:
      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

      # Function to generate a set based on supported systems:
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      nixpkgsFor =
        forAllSystems (system: import inputs.nixpkgs { inherit system; });

      modules = [
         {system = systemSettings.system ; }
         { environment.systemPackages = [ inputs.fh.packages.x86_64-linux.default ]; }

         # ... the rest of your modules here ...
         #./configuration.nix

         inputs.snowflake.nixosModules.snowflake
         inputs.nix-data.nixosModules.nix-data
         inputs.snowfall-lib.mkFlake {
            inherit inputs;
            src = ./.;

            overlays = with inputs; [
            # To make this flake's packages available in your NixPkgs package set.
              snowfall-flake.overlay
              snowfall-thaw.overlay
              snowfall-dotbox.overlay
          ]; }
      ];
    in {
      outputs.pkgSettings = import ./pkgs.nix ;
      homeConfigurations = {
        user = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/home.nix") # load home.nix from selected PROFILE
            #  inputs.nix-flatpak.homeManagerModules.nix-flatpak # Declarative flatpaks
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit pkgs-stable;
            inherit pkgs-emacs;
            inherit pkgs-kdenlive;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };
      nixosConfigurations = {

        Snowyfrank = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")
            #(./snowflakeos.nix)
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
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; #"https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-r2311.url = "nixpkgs/nixos-23.11";
    nixpkgs-r2211.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-python.url = "https://flakehub.com/f/cachix/nixpkgs-python/1.2.0.tar.gz";

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";

    snowfall-lib = {
      url = "https://flakehub.com/f/snowfallorg/lib/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs"; };
    snowfall-flake = {
      url = "https://flakehub.com/f/snowfallorg/flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs" ;};
    snowfall-thaw = {
      url = "https://flakehub.com/f/snowfallorg/thaw/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
        };
    snowfall-dotbox = {
      url = "https://flakehub.com/f/snowfallorg/dotbox/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
		};
    snowflakeos.url = "github:siryoussef/snowflakeos-modules";
    snowflakeos-module-manager = {
      url = "github:snowfallorg/snowflakeos-module-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      };
    nix-data={url = "github:snowfallorg/nix-data";
      inputs.nixpkgs.follows = "nixpkgs" ;};
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nixos-conf-editor.url = "github:vlinkz/nixos-conf-editor";
    snow.url = "github:snowflakelinux/snow";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    fleek.url = "https://flakehub.com/f/ublue-os/fleek/0.10.5.tar.gz";
    blincus.url = "https://flakehub.com/f/ublue-os/blincus/0.3.2.tar.gz";

    disko.url = "https://flakehub.com/f/nix-community/disko/1.3.0.tar.gz";
    vscode.url = "https://flakehub.com/f/catppuccin/vscode/3.11.1.tar.gz";
    ytdlp-gui.url = "https://flakehub.com/f/BKSalman/ytdlp-gui/1.0.1.tar.gz";
    NixVirt.url = "https://flakehub.com/f/AshleyYakeley/NixVirt/0.2.0.tar.gz";

    nix-gui.url = "github:nix-gui/nix-gui";
    compat.url = "github:balsoft/nixos-fhs-compat";
    #plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager = {
      url = "github:mcdonc/plasma-manager/enable-look-and-feel-settings";
      inputs={
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager-unstable";
        };
      };
    scientific-fhs.url = "github:olynch/scientific-fhs";

    emacs-pin-nixpkgs.url = "nixpkgs/f8e2ebd66d097614d51a56a755450d4ae1632df1";
    kdenlive-pin-nixpkgs.url = "nixpkgs/cfec6d9203a461d9d698d8a60ef003cac6d0da94";

    home-manager-unstable = {url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";};

    home-manager-stable= {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";};

    nix-doom-emacs = { url = "github:nix-community/nix-doom-emacs";
      inputs={nixpkgs.follows = "nixpkgs";
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
  };
  }
