{ pkgs, ... }:
{environment.systemPackages = with pkgs; [ distrobox boxbuddy ]; }
