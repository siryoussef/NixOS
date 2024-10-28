{ config, pkgs,  ... }:

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
