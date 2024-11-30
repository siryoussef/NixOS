{
  config,
  lib,
  dream2nix,
  pkgs,
  ...
}: {
  imports = [
    dream2nix.modules.dream2nix.pip
  ];

  deps = {nixpkgs, ...}: {
    python = nixpkgs.python3;
  };

  name = "voila";
  version = "0.5.8";

  buildPythonPackage = {
    pythonImportsCheck = [
      config.name
      "PIL"
    ];
  };
  mkDerivation = { #
    nativeBuildInputs = [
      config.deps.pkg-config
#       config.deps.wheel
#       config.deps.setuptools
      pkgs.python3Packages.wheel
      pkgs.python3Packages.setuptools
      pkgs.python3Packages.cython
      pkgs.gcc
    ];
    propagatedBuildInputs = [
#       config.deps.zlib
#       config.deps.libjpeg
    ];
  };


  paths.lockFile = "lock.${config.deps.stdenv.system}.json";
  pip = {
    requirementsList = ["${config.name}==${config.version}"]; #
    pipFlags = [ #
      "--no-binary=:all:"
#       ":all:"
#         "--prefer-binary"
    ];
  };
}
