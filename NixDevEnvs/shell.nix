 # shell.nix
let
  pkgs = import <nixpkgs> {};
  python = pkgs.python3;
  pythonPackages = python.pkgs;
in

with pkgs;

mkShell {
  name = "pip-env";
  buildInputs = with pythonPackages; [
#     jupyterlab-git
    jupyterlab-lsp
    jupyterlab-widgets
    jupyter-collaboration

    azure-cli
    kubectl

    # Python requirements (enough to get a virtualenv going).
    psutil
    #tensorflow
    #pyarrow
    pandas
    matplotlib
    seaborn
    scikit-learn
    tensorflow
    keras
    ipykernel
    jupyter
    pytest
    setuptools
    wheel
    venvShellHook

    libffi
    openssl
    gcc
    unzip
#     ipython-sql
#     sqlalchemy_1_4
#     pymysql

    imbalanced-learn
    statsmodels

    openpyxl
    nltk
  ];
  venvDir = "venv3";
  src = null;
  postVenv = ''
    unset SOURCE_DATE_EPOCH
    ./scripts/install_local_packages.sh
  '';
  postShellHook = ''
    # Allow the use of wheels.
    unset SOURCE_DATE_EPOCH

    # get back nice looking PS1
    source ~/.bashrc
    source <(kubectl completion bash)

    PYTHONPATH=$PWD/$venvDir/${python.sitePackages}:$PYTHONPATH
  '';
}

