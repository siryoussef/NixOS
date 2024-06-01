{ config, pkgs, ... }:

{
  imports = [ ./pipewire.nix
              ./dbus.nix
              ./gnome-keyring.nix
              ./fonts.nix
            ];

  environment.systemPackages = with pkgs;
    [ wayland waydroid
      (sddm-chili-theme.override {
        themeConfig = {
          background = config.stylix.image;
          ScreenWidth = 1920;
          ScreenHeight = 1080;
          blur = true;
          recursiveBlurLoops = 3;
          recursiveBlurRadius = 5;
        };})
    ];

  # Configure xwayland
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:escape";
      };
      resolutions = [ {x = 1920; y= 1080; } { x = 1600; y = 1200; } { x = 1280; y = 1024; } ];

    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
      };
  };
}
