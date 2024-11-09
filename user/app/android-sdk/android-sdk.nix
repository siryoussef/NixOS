{ config, pkgs, settings, inputs, lib, ... }:

{
              # inherit lib pkgs config;
              android-sdk= {
                enable = true;
                # path = "${config.home.homeDirectory}/.android/sdk"; # Optional; default path is "~/.local/share/android".
                packages = settings.pkglists.android-sdk-34;
              };
}