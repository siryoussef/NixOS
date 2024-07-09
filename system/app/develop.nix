 { pkgs, pkgs-stable, pkgs-r2211, userSettings, systemSettings, ... }:
{
environment.systemPackages= ((with pkgs;[
    jupyter-all
    mysqltuner
    mysql-workbench
    pkgs.rPackages.Anaconda
    # grafana
         # = { buildInputs = [ pkgs.qdarkstyle_3_02 ]; }; #( till errors are fixed : qdarkstyle & jedi versions not compatible/ packages not seen by spyder)
    devenv
    ]) ++ (with pkgs;(with python311Packages;[
    ipykernel
    pandas
    numpy
    matplotlib
    spyder
    spyder-kernels
    pyls-spyder
#     qdarkstyle
    ])));
services = {
    jupyterhub = {
    enable = false;
    jupyterlabEnv = pkgs.python3.withPackages (p: with p; [
        jupyterhub
        jupyterlab
        ipykernel
        numpy
        pandas
    ]); };
  jupyter = { enable = true; user = userSettings.username; group = "jupyter"; password = "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'"; };


  jupyter.kernels =
  {
  python3 = let
    env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
            jupyter
            jupyterlab-server
            ipykernel
            pandas
            scikit-learn
#              spyder
           # jedi
           # qdarkstyle
           # pyls-spyder
           # spyder-kernels
          ]));
  in {
    displayName = "Python 3 for machine learning";
    argv = [
      "${env.interpreter}"
      "-m"
      "ipykernel_launcher"
      "-f"
      "{connection_file}"
    ];
    language = "python";
#     logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
#     logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
    extraPaths = {
      "cool.txt" = pkgs.writeText "cool" "cool content";
    };
  };
};

  jupyter.package = pkgs-stable.python311Packages.notebook;

  /*
    mysql = {
        enable = true ;
        package = pkgs.mysql80;     #pkgs.mariadb;
        replication = {
            role = "master";
            serverId = 1 ;
            masterUser = "youssef";
            masterHost = "Snowyfrank";
            masterPassword = "123456";
            slaveHost = "wanky";
            };
    };
*/
};

/*
  ## MySQL server

  services.longview.mysqlUser = "youssef";
  services.longview.mysqlPassword = "123456";
*/

  /*
  users.mysql.enable = true ;
  users.mysql.user = "youssef";
  users.mysql.passwordFile = "/etc/mysql.password";
  #users.mysql.nss = import ./mysql-nss.cfg;
*/


  /*[
  (self: super: {
    spyder = super.spyder.override {
      postPatch = ''
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py \
      --replace "qdarkstyle>=3.0.2,<3.1.0" "qdarkstyle" \
      --replace "ipython>=7.31.1,<9.0.0,!=8.8.0,!=8.9.0,!=8.10.0,!=8.11.0,!=8.12.0,!=8.12.1" "ipython" \
      --replace "jedi>=0.17.2,<0.19.0" "jedi" \
      --replace "pylsp>=1.7.4,<1.8.0" "pylsp"
'';
    };
  })
];*/

  #linkedPackages = { "python311Packages.spyder". "python311Packages.spyder-kernels", "python311Packages.pyls-spyder", "python311Packages.qdarkstyle" }; };

}
