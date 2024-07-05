 { pkgs, ... }:

{
  environment.binsh = "${pkgs.dash}/bin/dash";
  programs = {
    zsh = {
      enable = true;
      autosuggestions = { enable = true; };
      syntaxHighlighting = { enable = true; };
      enableCompletion = true;
      enableBashCompletion = true;
      enableLsColors = true;

    };

    bash = {
      completion.enable = true;
      enableLsColors = true;
      blesh.enable = true;
      undistractMe = {enable = true; playSound = true; timeout= 21; };
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

    direnv = { enable = true; loadInNixShell = true; nix-direnv.enable = true;};
  };
}
