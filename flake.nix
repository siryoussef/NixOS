{description = "Flake of Snowyfrank";

  outputs = inputs@{ self,...}: import ./outputs.nix{inherit self inputs;};

  nixConfig={
    accept-flake-config=true;
    auto-optimise-store=true;
    allow-dirty=true;
    allow-import-from-derivation=true; # build during evaluation
    cores=6;
    download-attempts=7; # Nix's download trials no. before giving up
    download-speed=0; # unlimited
    eval-cache=true;
    fallback = false; # fallback to build from source if a binary attripute fails
    flake-registry = "https://channels.nixos.org/flake-registry.json";
    experimental-features=["nix-command" "flakes" "repl-flake"];
  };

  inputs ={
#     settings.url = "git+file:///etc/nixos/settings";
    flake-parts.url = "github:hercules-ci/flake-parts";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
#       home-manager.url = ("git+path:///etc/nixos/settings.nix").home-manager;

#     nixpkgs={url = "path:///etc/nixos/testing/nixpkgsRef/default.nix"; flake=false;};
#     nixpkgsRef={url = "path:///etc/nixos/nixpkgsRef";};
    nixpkgs.follows ="nixpkgs-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";#"https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs-r2311.url = "nixpkgs/nixos-23.11";
    nixpkgs-r2211.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-python.url = "https://flakehub.com/f/cachix/nixpkgs-python/1.2.0.tar.gz";
    kdenlive-pin-nixpkgs.url = "nixpkgs/cfec6d9203a461d9d698d8a60ef003cac6d0da94";
    nwg-dock-hyprland-pin-nixpkgs.url = "nixpkgs/2098d845d76f8a21ae4fe12ed7c7df49098d3f15";
    emacs-pin-nixpkgs.url = "nixpkgs/f8e2ebd66d097614d51a56a755450d4ae1632df1";


    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
    nh={url = "github:viperML/nh"; inputs.nixpkgs.follows="nixpkgs";};
    nur.url = "github:nix-community/NUR";
    qnr.url = "github:divnix/quick-nix-registry";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    snowfall-lib = {
      url = "https://flakehub.com/f/snowfallorg/lib/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    snowfall-flake = {
      url = "https://flakehub.com/f/snowfallorg/flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable" ;};
    snowfall-thaw = {
      url = "https://flakehub.com/f/snowfallorg/thaw/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
    snowfall-dotbox = {
      url = "https://flakehub.com/f/snowfallorg/dotbox/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
		};
    snowflakeos.url = "github:siryoussef/snowflakeos-modules";
    snowflakeos-module-manager = {
      url = "github:snowfallorg/snowflakeos-module-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
    nix-data={url = "github:snowfallorg/nix-data";
      inputs.nixpkgs.follows = "nixpkgs-unstable" ;};
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
        nixpkgs.follows = "nixpkgs-unstable";
#         home-manager.follows = "home-manager-unstable";
        };
      };
    nix-gui={url = "github:nix-gui/nix-gui";};
    compat.url = "github:balsoft/nixos-fhs-compat";
    #plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";#"github:mcdonc/plasma-manager/enable-look-and-feel-settings";
      inputs={
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager-unstable";
        };
      };
    hyprland = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/Hyprland.git";
      submodules = true;
      rev = "7a24e564f43d4c24abf2ec4e5351007df2f8926c"; #v0.42.0+
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      rev = "b73d7b901d8cb1172dd25c7b7159f0242c625a77"; #v0.42.0
      inputs.hyprland.follows = "hyprland";
    };
    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprgrass={url = "github:horriblename/hyprgrass/0bb3b822053c813ab6f695c9194089ccb5186cc3";
      inputs.hyprland.follows = "hyprland";};


    kwin-effects-forceblur={ url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs-unstable";};

    scientific-fhs.url = "github:olynch/scientific-fhs";



    home-manager-unstable = {url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";};

    home-manager-stable= {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";};

    nix-doom-emacs = { url = "github:nix-community/nix-doom-emacs";
      inputs={nixpkgs.follows = "nixpkgs-unstable";
        nix-straight.follows = "nix-straight"; }; };

    nix-straight={url = "github:librephoenix/nix-straight.el/pgtk-patch";
      flake = false;};
    eaf = {url = "github:emacs-eaf/emacs-application-framework";flake = false;};
    eaf-browser = {url = "github:emacs-eaf/eaf-browser"; flake = false;};
    org-nursery = {url = "github:chrisbarrett/nursery"; flake = false;};
    org-yaap = {url = "gitlab:tygrdev/org-yaap"; flake = false;};
    org-side-tree = {url = "github:localauthor/org-side-tree"; flake = false;};
    org-timeblock = {url = "github:ichernyshovvv/org-timeblock";flake = false;};
    org-krita = {url = "github:librephoenix/org-krita";flake = false;};
    org-xournalpp = {url = "gitlab:vherrmann/org-xournalpp";flake = false;};
    org-sliced-images = {url = "github:jcfk/org-sliced-images";flake = false;};
    magit-file-icons = {url = "github:librephoenix/magit-file-icons/abstract-icon-getters-compat";
      flake = false;};
    phscroll = {url = "github:misohena/phscroll"; flake = false;};
    mini-frame = {url = "github:muffinmad/emacs-mini-frame";flake = false;};

    stylix.url = "github:danth/stylix";

    rust-overlay.url = "github:oxalica/rust-overlay";

    blocklist-hosts = {url = "github:StevenBlack/hosts"; flake = false;};


    zen-browser={url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";};
    thorium-browser={url = #"github:siryoussef/nix-thorium";
#     "git+https://codeberg.org/Tomkoid/thorium-browser-nix";
#       "git+file:///Shared/@Repo/thorium-browser-nix/";
      "github:siryoussef/thorium-browser-nix";
      inputs.nixpkgs.follows="nixpkgs";
      };
    agenix={
      url = "github:ryantm/agenix";
      # optional, not necessary for the module
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      };
    quickgui={
      url = "https://flakehub.com/f/quickemu-project/quickgui/1.2.10.tar.gz";
      inputs.nixpkgs.follows="nixpkgs-unstable";
      };
    impermanence.url = /*"git+file:///Shared/@Repo/impermanence/";*/ "github:siryoussef/impermanence";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs={
        nixpkgs.follows = "nixpkgs-unstable";
#         nixpkgs-stable.follows = "nixpkgs-stable";
        };
    };
    wfvm={url = "git+https://git.m-labs.hk/M-Labs/wfvm";
      inputs.nixpkgs.follows = "nixpkgs";};
    winapps={url="github:siryoussef/winapps";
      inputs.nixpkgs.follows = "nixpkgs";};
    robotnix={url="github:siryoussef/robotnix";
      inputs={
        nixpkgs.follows="nixpkgs";
        nixpkgs-unstable.follows="nixpkgs-unstable";
        };
        };
  };
  }
