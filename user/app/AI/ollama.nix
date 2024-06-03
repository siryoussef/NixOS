{ config, pkgs, userSettings, ... }:

{
services = {
    ollama = {
        enable = true;
        models = "/Volume/@tmp/AIModels" ;
        };
    nextjs-ollama-llm-ui = {
        enable = true;

    };
    };

}
