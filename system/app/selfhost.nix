{pkgs',...}:
{
    services.homepage-dashboard={
        enable=true; listenPort=8082;
        package=pkgs'.stable.homepage-dashboard;
        services=[];
        bookmarks=[];
        widgets=[
            {
                resources = {
                cpu = true;
                disk = "/";
                memory = true;
                };
            }
            {
                search = {
                provider = "duckduckgo";
                target = "_blank";
                };
            }
        ];
        

    };
}