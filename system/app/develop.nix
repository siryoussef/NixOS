 { pkgs', settings, ... }:
{
environment.systemPackages= settings.pkglists.systemDevEnv;
services = {
    jupyterhub = {
    enable = false;
    jupyterlabEnv = settings.pkglists.jupyter.lab; };
  jupyter = {
    enable = true; 
    package = pkgs'.stable.python311Packages.notebook;
    user = settings.user.username; 
    group = "jupyter"; 
    password = settings.secrets.jupyter; 
    kernels = {
      python3 = let env = settings.pkglists.jupyter.kernels.python3; in {
        displayName = "Python 3 for machine learning";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
        # logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
        # logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
        # extraPaths = {"cool.txt" = pkgs'.main.writeText "cool" "cool content"; };
      };
    };
    notebookConfig = /*python*/
    ''
      c.notebook.ip = '127.0.0.1'
      c.notebook.port = 8889
      c.notebook.token = '3c4d9344a30c00d7bb25c5b247a1b695b1187283e810168d'
      c.notebook.ip = '127.0.0.1'
    
    '';  
  };



};

/*
  ## MySQL server

  services.longview.mysqlUser = settings.user.username;
  services.longview.mysqlPassword = "123456";
*/


#   users.mysql={enable = true ; user = settings.user.username; passwordFile = "${toString ../../secrets/mysql.age}";};
#   users.mysql.nss = import ./mysql-nss.cfg;



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
