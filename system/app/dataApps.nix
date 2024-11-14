{inputs, settings, config,...}:
rec{
services.opensearch={
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
environment.persistence= if services.opensearch.enable==true then let
storage = import settings.paths.storage{inherit settings config;};
in storage.persistent.opensearch.system else {};
}