{
  pkgs ? import <nixpkgs> {},
  # This allows us to provide a command to run via `--argstr run COMMAND`.
  run ? "bash"
}:
let
  lib = pkgs.lib;
  poetry2nix = pkgs.poetry2nix;
  python37 = pkgs.python37;
  poetry-env = poetry2nix.mkPoetryEnv {
        python = python37; # Python package to use
        pyproject = ./pyproject.toml; # Path to pyproject.toml
        poetrylock = ./poetry.lock; # Path to poetry.lock
  };
in
  with pkgs; (buildFHSUserEnv {
    name = "poetry-env-fhs";
    targetPkgs = pkgs: with pkgs; [
      # curl
      # git
      gcc
      gnumake
      python37Packages.poetry
      pandoc # for pdf conversion
      texlive.combined.scheme-full # for pdf conversion
      which # a convenient tool in vertualized environments
    ] ++ [
      poetry-env
    ];
    runScript = "${run}";
    profile = ''
      # export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      # export GIT_SSL_CAINFO="$SSL_CERT_FILE"
      # export LANG=C.UTF-8
    '';
  }).env

