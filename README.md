# NixOS
 My NixOS config files, forked from librephoenix (thanks emmet!) & my old config files, with the intention of propably adding some improvements present in ZaneyOS (nothing about this part in done yet)

# A Perfect OS (my moving target):

 **well, Isn't that every nixos users target? , however I have some relatively static clearly defined goals** :-
 
 1- A libreOS (as much as possiple without harming other goals) with modularity in mind.
 
 2- universal architecture & device compatibilty (cross platform).
 
 3- security in resonably performant manner (much more secure than windows & much more performant than qubes ).
 
 4- privacy : mainly by using alternative software.
 
 5- universal app compatibilty (think VMs, distrobox, Waydroid & Wine ).
 ....
 Well I lied a little about the targets clarity, however the target gets clearer as we move on
 
# Features
 1- full flatpak support, with declarative flatpaks.
 
 2- InRam-Root > faster purer environment.
 
 3- Waydroid.
 
 4- kde-plasma with plasma manager.
 
 5- floorp as main browser (now migrating to firedragon flatpak ).
 
 6- Home Manager (dual config (stanalone & nixos module) control).
 
 7- A nix-shell config (a regular non-flake one , will shift it to the main flake later).
 
 8-linux-zen kernel for better desktop performance.
 
# WIP

 1- Configuring distrobox declaratively (or just a usable declarative nix containers instead).
 
 2- Configuring Waydroid declaratively.
 
 3- Configuring jupyter & python environments declaratively (currently a nix-shell environment is working fine).
 
 4- In-Ram-Home (plasma-manager is currently in the way !).
 
 5- declarative secure passwords.
 
 6- Impermanence flake > better options for persistent storage other than simple bind mounts.
 
 7-declarative virt-manager VMs (using NixVirt), starting with a windows VM (currently an imperative setup works fine).
 
 8-testing lix & shifting from nix > lix.
 
 9-exploring system-manager for configuring nixos /etc files & maybe also arch linux (if not I will just shift my 2ry OS to debian or rhino).
 
 10- quickemu & quickgui for rapid VM deployment!
 
# TODO
1- declarative wine setup.

2- declarative SQL server.

3- declarative Waydroid environment (too much big of a target currently).

4- configuring disko.

5- exploring zen browser as an alternative to floorp & firedragon , configuring it's flatpak (or firedragon's one for that matter) to fill in place for the default browser.

6-nixos-wsl flake config.

7-nixOnDroid flake config.

8-flake-parts for better organization of that to-be huge flakes project.
