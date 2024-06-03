 { pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting = { enable = true; };
      enableCompletion = true;
      enableBashCompletion = true;
      enableLsColors = true;

    };

    bash = {
      enableCompletion = true;
      enableLsColors = true;
      blesh.enable = true;
      undistractme = {enable = true; playsound = true; timeout= 21; };
    };

    fish = {
      enable = true;
      useBabelfish = true;
      shellAbbrs = { gco = "git checkout"; npu = "nix-prefetch-url"; }; # set of fish sell abbreviations
      vendor = { config.enable = true; completions.enable = true; functions.enable = true;};
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
}
