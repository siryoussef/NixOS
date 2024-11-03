{pkgs', pkgs, lib,...}:
{
nixpkgs.config= {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["microsoft-edge-stable" "zoom" "beeper" "vscode" "code" "obsidian" ];
      permittedInsecurePackages = [ "electron-27.3.11" "xen-4.15.1" "olm-3.2.16" /* "openssl-1.1.1w" "openssl-1.1.1u"*/]; # to be revised later!!, olm is used in matrix & jitsi apps , it is mostly neochat who is the culprit! FIXME
      enableParallelBuildingByDefault = false;
      checkMeta = true;
      warnUndeclaredOptions = false;
      };
}
