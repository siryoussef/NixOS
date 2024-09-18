{ pkgs, ... }:
let

  # My shell aliases
  myAliases = {
    ls = "eza --icons -l -T -L=1";
    cat = "bat";
    htop = "btm";
    fd = "fd -Lu";
    w3m = "w3m -no-cookie -v";
    neofetch = "disfetch";
    fetch = "disfetch";
    gitfetch = "onefetch";
    nixos-rebuild = "systemd-run --no-ask-password --uid=0 --system --scope -p MemoryLimit=11000M -p CPUQuota=70% nixos-rebuild";
    home-manager = "systemd-run --no-ask-password --uid=1000 --user --scope -p MemoryLimit=11000M -p CPUQuota=70% home-manager";
    "," = "comma";
  };
in
{
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
#       enableBashCompletion = true;
#       enableLsColors = true;
      shellAliases = myAliases;
      initExtra = ''
      PROMPT=" ◉ %U%F{magenta}%n%f%u@%U%F{blue}%m%f%u:%F{yellow}%~%f
      %F{green}→%f "
      RPROMPT="%F{red}▂%f%F{yellow}▄%f%F{green}▆%f%F{cyan}█%f%F{blue}▆%f%F{magenta}▄%f%F{white}▂%f"
      [ $TERM = "dumb" ] && unsetopt zle && PS1='$ '
      '';
    };

    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = myAliases;
#       enableLsColors = true;
#       blesh.enable = true;
    };

    fish = {
      enable = true;
#       useBabelfish = true;
      shellAbbrs = { gco = "git checkout"; npu = "nix-prefetch-url"; }; # set of fish sell abbreviations
      shellAliases = myAliases;
#       vendor = { config.enable = true; completions.enable = true; functions.enable = true;};
      interactiveShellInit = "";
      loginShellInit = "";
    };
    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      };
  };

  home.packages = with pkgs; [
    disfetch lolcat cowsay onefetch
    gnugrep gnused
    bat eza bottom fd bc
    direnv nix-direnv
  ];


}
