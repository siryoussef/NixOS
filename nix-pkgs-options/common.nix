{pkgs', lib, inputs,...}:
{
imports=[
#   ./config.nix
#   ./nix.nix
];
nixpkgs = {
    config= {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["microsoft-edge-stable" "zoom" "beeper" "vscode" "code" "obsidian" ];
      permittedInsecurePackages = [ "electron-27.3.11" "xen-4.15.1" "olm-3.2.16" /* "openssl-1.1.1w" "openssl-1.1.1u"*/]; # to be revised later!!, olm is used in matrix & jitsi apps , it is mostly neochat who is the culprit! FIXME
      enableParallelBuildingByDefault = false;
      checkMeta = true;
      warnUndeclaredOptions = false;

      android_sdk.accept_license = true;
      };
    overlays = (with inputs;[
                rust-overlay.overlays.default
                snowfall-flake.overlays.default
                android-nixpkgs.overlays.default
                ytdlp-gui.overlay
                nur.overlay
                ])++[
            (final: prev: {
              voila = final.python311Packages.buildPythonPackage rec {
                pname = "voila";
                version = "0.5.8";

                src = final.fetchFromGitHub {
                  owner = "voila-dashboards";
                  repo = "voila";
                  rev = "v${version}";
                  sha256 = "sha256-Np7tC2sq/imTXpXE1nKQFhF69TK9lgOCXKThOEA9vLs="; # Replace this with the actual hash
                };

                propagatedBuildInputs = with final.python311Packages; [
                  notebook
                  jupyter-server
                  nbconvert
                  traitlets
                ];

                # Fix package discovery error
                postPatch = ''
                  echo "from setuptools import setup; setup(packages=['voila'])" > setup.py
                '';

                meta = with final.lib; {
                  description = "Voila turns Jupyter notebooks into standalone web applications";
                  homepage = "https://github.com/voila-dashboards/voila";
                  license = licenses.bsd3;
                };
              };
            })
          ];
    };
nix={
# 	package = pkgs.nixVersions.latest;
  # Fix nix path
	nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixpkgs-stable=${inputs.nixpkgs-stable}"
      "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
# 		"nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
# 		"nixos-config=$HOME/dotfiles/system/configuration.nix"
# 		"/nix/var/nix/profiles/per-user/root/channels"
#   "$HOME/.nix-defexpr/channels"
#   "darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix"
	];
	extraOptions = ''
		experimental-features = nix-command flakes
		keep-outputs = true
		keep-derivations = true
	'';
	checkAllErrors = true;
	checkConfig = true;
	optimise = { automatic = true; dates = [ "weekly" ]; };
#   gc = { automatic = (if config.programs.nh.clean.enable==true then false else true);  dates = "weekly"; };
  channel.enable = true;
  settings = { auto-optimise-store = true;
               experimental-features = ["nix-command " "flakes" /*"configurable-impure-env"*/ "auto-allocate-uids"] ; };
  #registry = { };
  #registry = { "flakes"=[]  "version" 2; };



# 	settings=
# 	registry=
# 	channels={ inherit pkgs; };
	};
}
# {pkgs ? import <nixpkgs>, config,...}:
# {
# }
# ##Home-manager Only
# # 	keepOldNixPath=true; # Whether nix.nixPath should keep the previously set values in NIX_PATH.
# ##
