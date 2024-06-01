{ config, pkgs, userSettings, ... }:
{
    services.chatgpt-retrieval-plugin = {
        enable = true;

        #host = "192.168.111.121" ;
        port= "8080";
        openaiApiKeyPath = "/Shared/@Home/OpenAIKey.txt";
        #bearerTokenPath = ;
        qdrantCollection = "document_chunks";

        datastore = "qdrant";

    };
}
