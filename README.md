# SiragOS 
 My NixOS config files, forked from librephoenix (thanks emmet!) & my old config files, with the intention of propably adding some improvements present in ZaneyOS (nothing about this part in done yet)

# A Better OS ..... a moving target? :

 **well, Isn't that every nixos users target? , however I have some relatively clearly defined goals** :-
 
 1- A libreOS yet convenient with modularity in mind.
 
 2- universal architecture & device compatibilty (cross platform).
 
 3-universal app compatibilty (think VMs, distrobox, Waydroid & Wine ).

 4- privacy : mainly by using alternative software.
 
 5- security in resonably performant manner (much more secure than windows & much more performant than qubes ).

 6- universal environment compatibility! , think VMs, Containers, devShells , home-manager on other OSes !
 ....
 Well I lied a little about the targets clarity, however the target gets clearer as we move on
 
# Features
 1- full flatpak support, with declarative flatpaks.
 
 2- Impermanence with InRam-Root & In-Ram-Home

 3-kde-plasma w. plasma-manager (currently disabled but to be enabled in the future)
 
 4- Waydroid.
 
 5- floorp as main browser (now migrating to firedragon flatpak ).
 
 6- Home Manager (dual config (stanalone & nixos module) control).
 
 7- A nix-shell config (a regular non-flake one , will shift it to the main flake later).
 
 8-linux-zen kernel for better desktop performance.

 9-using lix (a better nix!)

 
# WIP

 1- Configuring distrobox declaratively (or just a usable declarative nix containers instead).
 
 2- Configuring Waydroid declaratively.
 
 3- Configuring jupyter & python environments declaratively (currently a nix-shell environment is working fine).
 
 4- declarative secure passwords.
 
 5- configuring virt-manager dotfiles w.dconf declartively
 6-declarative virt-manager VMs (using NixVirt), starting with a windows VM (currently an imperative setup works fine).
 
 7-exploring zen browser as an alternative to floorp & firedragon , configuring it's flatpak (or firedragon's one for that matter) to fill in place for the default browser.
 
 8-exploring system-manager for configuring nixos /etc files & maybe also arch linux (if not I will just shift my 2ry OS to debian or rhino).
 
 9- quickemu & quickgui for rapid VM deployment!

 10-flake-parts for better organization of that to-be huge flakes project.

 11-adding wfvm for windows apps that don't run on wine!

 12-winapps for using any windows app with best performance inside linux desktop environments/wms!
 
# TODO
1- declarative wine setup.

2- declarative SQL server.

3- declarative Waydroid environment (too much big of a target currently , maybe with robotnix , with planning to further develop or to find an alternative if possiple!)

4- configuring disko.

5-nixos-wsl flake config.

6-nixOnDroid flake config.

7-adjusting nix-shell environment & adding it to nixos if possiple!

8-adding local AI models w.flake-parts services flakes & maybe nixified AI (if found useful, i.e. too old now)

9- potentially handling root user directory with home-manager?

10- Building a DaC streamlining environment , starting with dvc

11- fixing emmet's Emacs building errors (readapting emacs customizations to current build )


