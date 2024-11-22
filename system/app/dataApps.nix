{inputs, pkgs', settings, config,...}:
let 
storage=import settings.paths.storage{inherit settings config;};
in
rec{
services=rec{
  opensearch={
    enable=false;
    settings={

    };
    logging=''
      logger.action.name = org.opensearch.action
      logger.action.level = info

      appender.console.type = Console
      appender.console.name = console
      appender.console.layout.type = PatternLayout
      appender.console.layout.pattern = [%d{ISO8601}][%-5p][%-25c{1.}] %marker%m%n

      rootLogger.level = info
      rootLogger.appenderRef.console.ref = console
    '';
  };
  grafana = {
    enable = true;
    package = pkgs'.main.grafana;
    dataDir = settings.paths.persistentSystem+"/var/lib/grafana";
    declarativePlugins = with pkgs'.stable.grafanaPlugins; [ grafana-piechart-panel ];
    settings = {
      security = {
        admin_email = settings.user.email;
        admin_password = settings.secrets.grafana.adminPass;
        admin_user = settings.user.username;
        secret_key = settings.secrets.grafana.secretKey;
        content_security_policy=true;
      };
      users = {
        default_language=settings.system.language;
      };
      server = {
        protocol = "http";
        http_port = 3000;
        http_addr = "127.0.0.9";
        domain = "grafana"; #"localhost";
        # root_url="%(protocol)s://%(domain)s:%(http_port)s/";
        enable_gzip = true;
      };
      analytics = {
        reporting_enabled=false;
        feedback_links_enabled=true;
        # check_for_plugin_updates=true; ## default = cfg.declarativePlugins == null
      };
      database={
        host="127.0.0.1:3306";
      };
      paths={
        # plugins=settings.paths.grafana.plugins;  # if (cfg.declarativePlugins == null) then "${cfg.dataDir}/plugins" else declarativePlugins
        # provision=settings.paths.grafana.provision;
      };
    };
    provision={
      enable=true;
      datasources={
        settings={
          apiVersion=1;
          datasources=[

          ];
          deleteDatasources=[

          ];
        };
      };
      dashboards={
        # path=settings.paths.grafana.dashboardspath; # Path to YAML dashboard configuration. Can't be used with simultaneously. Can be either a directory or a single YAML file. Will end up in the store.
        settings={
          apiVersion=1;
          providers=[
            
          ];
        };
      };
      alerting={
        templates={
          # path = settings.paths.grafana.alertTemplates;
          settings={
            apiVersion = 1;
            templates = [
              # { orgId = 1; name = "my_first_template"; template = "Alerting with a custom text template"; }
            ];
            deleteTemplates = [
              # { orgId = 1; name = "my_first_template"; }
            ];
          };
        };
        rules={

        };
        policies={

        };
        muteTimings={
          settings={
            apiVersion = 1;
            muteTimes = [
              # { orgId = 1; name = "mti_1";
              # time_intervals = [
              #   { times = [
              #       { start_time = "06:00"; end_time = "23:59"; }
              #     ];
              #     weekdays = [
              #       "monday:wednesday"
              #       "saturday"
              #       "sunday"
              #     ];
              #     months = [
              #       "1:3"
              #       "may:august"
              #       "december"
              #     ];
              #     years = [
              #       "2020:2022"
              #       "2030"
              #     ];
              #     days_of_month = [
              #       "1:5"
              #       "-3:-1"
              #     ];
              #   }
              # ];}
            ];

            deleteMuteTimes = [
              # { orgId = 1; name = "mti_1"; }
            ];
          };

        };
        contactPoints={
          # path=settings.paths.grafana.alertContactPoints;
          settings = {
            apiVersion = 1;

            contactPoints = [
              # { orgId = 1; name = "cp_1"; receivers = [
              #   { uid = "first_uid"; type = "prometheus-alertmanager"; settings.url = "http://test:9000"; }
              #   ];
              # }
              ];

            deleteContactPoints = [
              # { orgId = 1; uid = "first_uid"; }
              ];
          };
        };
      };

    };

  };
  grafana-agent={
    enable=if grafana.enable==true then true else false;
    package=pkgs'.stable.grafana-agent;
    settings={
      server={

      };

    };
    credentials={
#       LOGS_REMOTE_WRITE_URL = "/run/keys/grafana_agent_logs_remote_write_url";
#       LOGS_REMOTE_WRITE_USERNAME = "/run/keys/grafana_agent_logs_remote_write_username";
#       METRICS_REMOTE_WRITE_URL = "/run/keys/grafana_agent_metrics_remote_write_url";
#       METRICS_REMOTE_WRITE_USERNAME = "/run/keys/grafana_agent_metrics_remote_write_username";
#       logs_remote_write_password = "/run/keys/grafana_agent_logs_remote_write_password";
#       metrics_remote_write_password = "/run/keys/grafana_agent_metrics_remote_write_password";
    };
  };
  grafana_reporter={
    enable=/*if grafana.enable==true then true else */false;
    templateDir=pkgs'.stable.grafana_reporter;
    addr="127.0.0.1";
  };
  grafana-image-renderer={
    enable=false; /*if grafana.enable==true then true else false;*/
    provisionGrafana=true;
    settings={};
    verbose=true;
    chromium=pkgs'.main.ungoogled-chromium;
  };
  mysql = {
        enable = true ;
        package = /*pkgs'.main.mysql80;*/  pkgs'.main.mariadb;
#         bindAddress = "0.0.0.0";
        initialScript = ./mysqlscript.txt;
        initialDatabases=[
          ##examples##
          # { name = "foodatabase"; schema = ./foodatabase.sql; }
          # { name = "bardatabase"; }
        ];
        user = "mysql";
        group = "mysql";
        dataDir = "/var/lib/mysql";
        ensureUsers = [
          ##examples##
          # { name = "nextcloud"; ensurePermissions = {"nextcloud.*" = "ALL PRIVILEGES";};  }
          # { name = "backup"; ensurePermissions = {"*.*" = "SELECT, LOCK TABLES";}; }
        ];
        replication = {
            role = "master"; ## one of "master", "slave", "none"
            serverId = 1 ;
            masterUser = settings.user.username;
            masterHost = settings.system.hostname;
            masterPassword = settings.secrets.MySQL-masterPass;
            slaveHost = "wanky";
            };
            
    };
};
environment.persistence= if services.opensearch.enable==true then let
storage = import settings.paths.storage{inherit settings config;};
in storage.persistent.opensearch.system else {};
}
