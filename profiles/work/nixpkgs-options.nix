{pkgs, lib,...}:
{
nixpkgs = {
    config= {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["microsoft-edge-stable" "zoom" "beeper" "vscode" "code" "obsidian" ];
      permittedInsecurePackages = [ "electron-27.3.11" "xen-4.15.1"/* "openssl-1.1.1w" "openssl-1.1.1u"*/];
      enableParallelBuildingByDefault = false;
      checkMeta = true;
      warnUndeclaredOptions = false;
      };
    };
}
