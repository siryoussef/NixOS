{settings, pkgs', config,...}:
{
programs.vscode ={
  enable=true;
  package=pkgs'.main.vscode-fhs;
  enableExtensionUpdateCheck=true;
  enableUpdateCheck=true;
#   haskell ={enable=true; hie={enable=true; /*executablePath="${pkgs.hie-nix.hies}/bin/hie-wrapper";*/};};
#   userSettings={"files.autoSave" = "off"; "[nix]"."editor.tabSize" = 2;};

};
home.packages=settings.pkglists.vscode;
home.file=let storage= import settings.paths.storage{inherit settings config;}; in storage.homeLinks.vscode // {".config/Code/User/settings.json"={ #FIXME
  enable = false; text = ''
{
    "easycode.model": "gpt-3.5-turbo",
    "easycode.codeLens": true,
    "easycode.useActiveViewContext": true,
    "easycode.userEmail": "${settings.user.email}",
    "easycode.openAI ApiKey": "${settings.secrets.openAIKey}",
    "easycode.useOwnApiKey": true,
    "git.enableSmartCommit": true,
    "git.autofetch": true,
    "[nix]": {}

  "nix.serverPath": "nixd",
  "nix.enableLanguageServer": true,
  "nix.serverSettings": {
    "nixd": {
      "formatting": {
        "command": [ "alejandra" ], // or nixfmt or nixpkgs-fmt
      },
      // "options": {
      //    "nixos": {
      //      "expr": "(builtins.getFlake \"/PATH/TO/FLAKE\").nixosConfigurations.CONFIGNAME.options"
      //    },
      //    "home_manager": {
      //      "expr": "(builtins.getFlake \"/PATH/TO/FLAKE\").homeConfigurations.CONFIGNAME.options"
      //    },
      // },
    }
  }
}

''; };
};
}
