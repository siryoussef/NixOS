{pkgs', lib,...}:
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
      };
    };
nix={
# 	package = pkgs.nixVersions.latest;
  # Fix nix path
	nixPath = [
		"nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
		"nixos-config=$HOME/dotfiles/system/configuration.nix"
		"/nix/var/nix/profiles/per-user/root/channels"
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
