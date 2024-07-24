{ pkgs,/*config, lib,  font, userSettings, systemSettings,inputs,*/ ...}:

{

  programs.plasma = {
    enable = true;
    workspace = {
      clickItemTo = "open"; # If you liked the click-to-open default from plasma 5
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 32;
      };
      iconTheme = "Papirus-Dark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };

    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Alt+K";
      command = "konsole";
    };
    powerdevil = {
      powerButtonAction = "lockScreen";
      autoSuspend = {
        action = "shutDown";
        idleTimeout = 1000;
      };
      turnOffDisplay = {
        idleTimeout = 1000;
        idleTimeoutWhenLocked = "immediately";
      };
    };

    fonts = {
      general = {
        family = "JetBrains Mono";
        pointSize = 12;
      };
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
                alphaSort = true;
              };
            };
          }
          # Or you can configure the widgets by adding the widget-specific options for it.
          # See modules/widgets for supported widgets and options for these widgets.
          # For example:
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          # Adding configuration to the widgets can also for example be used to
          # pin apps to the task-manager, which this example illustrates by
          # pinning dolphin and konsole to the task-manager by default with widget-specific options.
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
              ];
            };
          }
          # Or you can do it manually, for example:
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.konsole.desktop"
                ];
              };
            };
          }
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.marginsseparator"
          # If you need configuration for your widget, instead of specifying the
          # the keys and values directly using the config attribute as shown
          # above, plasma-manager also provides some higher-level interfaces for
          # configuring the widgets. See modules/widgets for supported widgets
          # and options for these widgets. The widgets below shows two examples
          # of usage, one where we add a digital clock, setting 12h time and
          # first day of the week to Sunday and another adding a systray with
          # some modifications in which entries to show.
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "12h";
            };
          }
          {
            systemTray.items = {
              # We explicitly show bluetooth and battery
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
              ];
              # And explicitly hide networkmanagement and volume
              hidden = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
            };
          }
        ];
        hiding = "autohide";
      }
      # Application name, Global menu and Song information and playback controls at the top
      {
        location = "top";
        height = 26;
        widgets = [
          {
            applicationTitleBar = {
              behavior = {
                activeTaskSource = "activeTask";
              };
              layout = {
                elements = [ "windowTitle" ];
                horizontalAlignment = "left";
                showDisabledElements = "deactivated";
                verticalAlignment = "center";
              };
              overrideForMaximized.enable = false;
              titleReplacements = [
                {
                  type = "regexp";
                  originalTitle = "^Brave Web Browser$";
                  newTitle = "Brave";
                }
                {
                  type = "regexp";
                  originalTitle = ''\\bDolphin\\b'';
                  newTitle = "File manager";
                }
              ];
              windowTitle = {
                font = {
                  bold = false;
                  fit = "fixedSize";
                  size = 12;
                };
                hideEmptyTitle = true;
                margins = {
                  bottom = 0;
                  left = 10;
                  right = 5;
                  top = 0;
                };
                source = "appName";
              };
            };
          }
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
#           {
#             plasmusicToolbar = {
#               panelIcon = {
#                 albumCover = {
#                   useAsIcon = false;
#                   radius = 8;
#                 };
#                 icon = "view-media-track";
#               };
#               preferredSource = "spotify";
#               showPlaybackControls = true;
#               songText = {
#                 displayInSeparateLines = true;
#                 maximumWidth = 640;
#                 scrolling = {
#                   behavior = "alwaysScroll";
#                   speed = 3;
#                 };
#               };
#             };
#           }
        ];
      }
    ];

     window-rules = [
      {
        description = "Dolphin";
        match = {
          window-class = {
            value = "dolphin";
            type = "substring";
          };
          window-types = [ "normal" ];
        };
        apply = {
          noborder = {
            value = true;
            apply = "force";
          };
          # `apply` defaults to "apply-initially"
          maximizehoriz = true;
          maximizevert = true;
        };
      }
    ];

    shortcuts = {
      "ActivityManager"."switch-to-activity-9dcd47d6-8787-4dd4-b599-405921c53662" = [ ];
      "KDE Keyboard Layout Switcher"={
        "Switch keyboard layout to Arabic (Egypt)" = [ ];
        "Switch keyboard layout to English (US)" = [ ];
        "Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
        "Switch to Next Keyboard Layout" = "none,Meta+Alt+K,Switch to Next Keyboard Layout";
        };
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"={ "Disable Touchpad" = "Touchpad Off"; "Enable Touchpad" = "Touchpad On";
        "Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku"];
        };
      "khotkeys"."{d03619b6-9b3c-48cc-9d9c-a2aadb485550}" = "Meta+C,none,Search";
      "kmix" = {
        "decrease_microphone_volume" = "Microphone Volume Down";
        "decrease_volume" = "Volume Down";
        "decrease_volume_small" = "Shift+Volume Down";
        "increase_microphone_volume" = "Microphone Volume Up";
        "increase_volume" = "Volume Up";
        "increase_volume_small" = "Shift+Volume Up";
        "mic_mute" = ["Microphone Mute" "Meta+Volume Mute,Microphone Mute" "Meta+Volume Mute,Mute Microphone"];
        "mute" = "Volume Mute";
        };
      "ksmserver"={
        "Halt Without Confirmation" = "none,,Shut Down Without Confirmation";
        "Lock Session" = ["Meta+L" "Screensaver,Meta+L" "Screensaver,Lock Session"];
        "Log Out" = "Ctrl+Alt+Del";
        "Log Out Without Confirmation" = "none,,Log Out Without Confirmation";
        "LogOut" = "none,,Log Out";
        "Reboot" = "none,,Reboot";
        "Reboot Without Confirmation" = "none,,Reboot Without Confirmation";
        "Shut Down" = "none,,Shut Down";
        };
      "kwin" = {
        "Activate Window Demanding Attention" = "Meta+Ctrl+A";
        "Cycle Overview" = [ ];
        "Cycle Overview Opposite" = [ ];
        "Decrease Opacity" = "none,,Decrease Opacity of Active Window by 5%";
        "Edit Tiles" = "Meta+T";
        "Expose" = "Ctrl+F9";
        "ExposeAll" = ["Ctrl+F10" "Launch (C),Ctrl+F10" "Launch (C),Toggle Present Windows (All desktops)"];
        "ExposeClass" = "Ctrl+F7";
        "ExposeClassCurrentDesktop" = [ ];
        "Grid View" = "Meta+G";
        "Increase Opacity" = "none,,Increase Opacity of Active Window by 5%";
        "Kill Window" = "Meta+Ctrl+Esc";
        "Move Tablet to Next Output" = [ ];
        "MoveMouseToCenter" = "Meta+F6";
        "MoveMouseToFocus" = "Meta+F5";
        "MoveZoomDown" = [ ];
        "MoveZoomLeft" = [ ];
        "MoveZoomRight" = [ ];
        "MoveZoomUp" = [ ];
        "Overview" = "Meta+W";
        "Setup Window Shortcut" = "none,,Setup Window Shortcut";
        "Show Desktop" = "Meta+D";
        "ShowDesktopGrid" = "Meta+F8";
        "Suspend Compositing" = "Alt+Shift+F12";
        "Switch One Desktop Down" = "Meta+Ctrl+Down";
        "Switch One Desktop Up" = "Meta+Ctrl+Up";
        "Switch One Desktop to the Left" = "Meta+Ctrl+Left";
        "Switch One Desktop to the Right" = "Meta+Ctrl+Right";
        "Switch Window Down" = "Meta+Alt+Down";
        "Switch Window Left" = "Meta+Alt+Left";
        "Switch Window Right" = "Meta+Alt+Right";
        "Switch Window Up" = "Meta+Alt+Up";
        "Switch to Desktop 1" = "Ctrl+F1";
        "Switch to Desktop 10" = "none,,Switch to Desktop 10";
        "Switch to Desktop 11" = "none,,Switch to Desktop 11";
        "Switch to Desktop 12" = "none,,Switch to Desktop 12";
        "Switch to Desktop 13" = "none,,Switch to Desktop 13";
        "Switch to Desktop 14" = "none,,Switch to Desktop 14";
        "Switch to Desktop 15" = "none,,Switch to Desktop 15";
        "Switch to Desktop 16" = "none,,Switch to Desktop 16";
        "Switch to Desktop 17" = "none,,Switch to Desktop 17";
        "Switch to Desktop 18" = "none,,Switch to Desktop 18";
        "Switch to Desktop 19" = "none,,Switch to Desktop 19";
        "Switch to Desktop 2" = "Ctrl+F2";
        "Switch to Desktop 20" = "none,,Switch to Desktop 20";
        "Switch to Desktop 3" = "Ctrl+F3";
        "Switch to Desktop 4" = "Ctrl+F4";
        "Switch to Desktop 5" = "none,,Switch to Desktop 5";
        "Switch to Desktop 6" = "none,,Switch to Desktop 6";
        "Switch to Desktop 7" = "none,,Switch to Desktop 7";
        "Switch to Desktop 8" = "none,,Switch to Desktop 8";
        "Switch to Desktop 9" = "none,,Switch to Desktop 9";
        "Switch to Next Desktop" = "none,,Switch to Next Desktop";
        "Switch to Next Screen" = "none,,Switch to Next Screen";
        "Switch to Previous Desktop" = "none,,Switch to Previous Desktop";
        "Switch to Previous Screen" = "none,,Switch to Previous Screen";
        "Switch to Screen 0" = "none,,Switch to Screen 0";
        "Switch to Screen 1" = "none,,Switch to Screen 1";
        "Switch to Screen 2" = "none,,Switch to Screen 2";
        "Switch to Screen 3" = "none,,Switch to Screen 3";
        "Switch to Screen 4" = "none,,Switch to Screen 4";
        "Switch to Screen 5" = "none,,Switch to Screen 5";
        "Switch to Screen 6" = "none,,Switch to Screen 6";
        "Switch to Screen 7" = "none,,Switch to Screen 7";
        "Switch to Screen Above" = "none,,Switch to Screen Above";
        "Switch to Screen Below" = "none,,Switch to Screen Below";
        "Switch to Screen to the Left" = "none,,Switch to Screen to the Left";
        "Switch to Screen to the Right" = "none,,Switch to Screen to the Right";
        "Toggle Night Color" = [ ];
        "Toggle Window Raise/Lower" = "none,,Toggle Window Raise/Lower";
        "Walk Through Desktop List" = [ ];
        "Walk Through Desktop List (Reverse)" = [ ];
        "Walk Through Desktops" = [ ];
        "Walk Through Desktops (Reverse)" = [ ];
        "Walk Through Windows" = "Alt+Tab";
        "Walk Through Windows (Reverse)" = "Alt+Shift+Backtab,Alt+Shift+Tab,Walk Through Windows (Reverse)";
        "Walk Through Windows Alternative" = "none,,Walk Through Windows Alternative";
        "Walk Through Windows Alternative (Reverse)" = "none,,Walk Through Windows Alternative (Reverse)";
        "Walk Through Windows of Current Application" = "Alt+`";
        "Walk Through Windows of Current Application (Reverse)" = "Alt+~";
        "Walk Through Windows of Current Application Alternative" = "none,,Walk Through Windows of Current Application Alternative";
        "Walk Through Windows of Current Application Alternative (Reverse)" = "none,,Walk Through Windows of Current Application Alternative (Reverse)";
        "Window Above Other Windows" = "none,,Keep Window Above Others";
        "Window Below Other Windows" = "none,,Keep Window Below Others";
        "Window Close" = "Alt+F4";
        "Window Fullscreen" = "none,,Make Window Fullscreen";
        "Window Grow Horizontal" = "none,,Expand Window Horizontally";
        "Window Grow Vertical" = "none,,Expand Window Vertically";
        "Window Lower" = "none,,Lower Window";
        "Window Maximize" = "Meta+PgUp";
        "Window Maximize Horizontal" = "none,,Maximize Window Horizontally";
        "Window Maximize Vertical" = "none,,Maximize Window Vertically";
        "Window Minimize" = "Meta+PgDown";
        "Window Move" = "none,,Move Window";
        "Window Move Center" = "none,,Move Window to the Center";
        "Window No Border" = "none,,Toggle Window Titlebar and Frame";
        "Window On All Desktops" = "none,,Keep Window on All Desktops";
        "Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
        "Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
        "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
        "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
        "Window One Screen Down" = "none,,Move Window One Screen Down";
        "Window One Screen Up" = "none,,Move Window One Screen Up";
        "Window One Screen to the Left" = "none,,Move Window One Screen to the Left";
        "Window One Screen to the Right" = "none,,Move Window One Screen to the Right";
        "Window Operations Menu" = "Alt+F3";
        "Window Pack Down" = "none,,Move Window Down";
        "Window Pack Left" = "none,,Move Window Left";
        "Window Pack Right" = "none,,Move Window Right";
        "Window Pack Up" = "none,,Move Window Up";
        "Window Quick Tile Bottom" = "Meta+Down";
        "Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
        "Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
        "Window Quick Tile Left" = "Meta+Left";
        "Window Quick Tile Right" = "Meta+Right";
        "Window Quick Tile Top" = "Meta+Up";
        "Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
        "Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";
        "Window Raise" = "none,,Raise Window";
        "Window Resize" = "none,,Resize Window";
        "Window Shade" = "none,,Shade Window";
        "Window Shrink Horizontal" = "none,,Shrink Window Horizontally";
        "Window Shrink Vertical" = "none,,Shrink Window Vertically";
        "Window to Desktop 1" = "none,,Window to Desktop 1";
        "Window to Desktop 10" = "none,,Window to Desktop 10";
        "Window to Desktop 11" = "none,,Window to Desktop 11";
        "Window to Desktop 12" = "none,,Window to Desktop 12";
        "Window to Desktop 13" = "none,,Window to Desktop 13";
        "Window to Desktop 14" = "none,,Window to Desktop 14";
        "Window to Desktop 15" = "none,,Window to Desktop 15";
        "Window to Desktop 16" = "none,,Window to Desktop 16";
        "Window to Desktop 17" = "none,,Window to Desktop 17";
        "Window to Desktop 18" = "none,,Window to Desktop 18";
        "Window to Desktop 19" = "none,,Window to Desktop 19";
        "Window to Desktop 2" = "none,,Window to Desktop 2";
        "Window to Desktop 20" = "none,,Window to Desktop 20";
        "Window to Desktop 3" = "none,,Window to Desktop 3";
        "Window to Desktop 4" = "none,,Window to Desktop 4";
        "Window to Desktop 5" = "none,,Window to Desktop 5";
        "Window to Desktop 6" = "none,,Window to Desktop 6";
        "Window to Desktop 7" = "none,,Window to Desktop 7";
        "Window to Desktop 8" = "none,,Window to Desktop 8";
        "Window to Desktop 9" = "none,,Window to Desktop 9";
        "Window to Next Desktop" = "none,,Window to Next Desktop";
        "Window to Next Screen" = "Meta+Shift+Right";
        "Window to Previous Desktop" = "none,,Window to Previous Desktop";
        "Window to Previous Screen" = "Meta+Shift+Left";
        "Window to Screen 0" = "none,,Move Window to Screen 0";
        "Window to Screen 1" = "none,,Move Window to Screen 1";
        "Window to Screen 2" = "none,,Move Window to Screen 2";
        "Window to Screen 3" = "none,,Move Window to Screen 3";
        "Window to Screen 4" = "none,,Move Window to Screen 4";
        "Window to Screen 5" = "none,,Move Window to Screen 5";
        "Window to Screen 6" = "none,,Move Window to Screen 6";
        "Window to Screen 7" = "none,,Move Window to Screen 7";
        "view_actual_size" = "Meta+0";
        "view_zoom_in" = ["Meta++" "Meta+=,Meta++" "Meta+=,Zoom In"];
        "view_zoom_out" = "Meta+-";
      };

      "mediacontrol" = {
        "mediavolumedown" = "none,,Media volume down";
        "mediavolumeup" = "none,,Media volume up";
        "nextmedia" = "Media Next";
        "pausemedia" = "Media Pause";
        "playmedia" = "none,,Play media playback";
        "playpausemedia" = "Media Play";
        "previousmedia" = "Media Previous";
        "stopmedia" = "Media Stop";
        };

      "org_kde_powerdevil" = {
        "Decrease Keyboard Brightness" = "Keyboard Brightness Down";
        "Decrease Screen Brightness" = "Monitor Brightness Down";
        "Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
        "Hibernate" = "Hibernate";
        "Increase Keyboard Brightness" = "Keyboard Brightness Up";
        "Increase Screen Brightness" = "Monitor Brightness Up";
        "Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
        "PowerDown" = "Power Down";
        "PowerOff" = "Power Off";
        "Sleep" = "Sleep";
        "Toggle Keyboard Backlight" = "Keyboard Light On/Off";
        "Turn Off Screen" = [ ];
        "powerProfile" = ["Battery" "Meta+B,Battery" "Meta+B,Switch Power Profile"];
        };
      "plasmashell"={
        "activate application launcher" = ["none,Meta" "Alt+F1,Activate Application Launcher"];
        "activate task manager entry 1" = "Meta+1";
        "activate task manager entry 10" = "none,Meta+0,Activate Task Manager Entry 10";
        "activate task manager entry 2" = "Meta+2";
        "activate task manager entry 3" = "Meta+3";
        "activate task manager entry 4" = "Meta+4";
        "activate task manager entry 5" = "Meta+5";
        "activate task manager entry 6" = "Meta+6";
        "activate task manager entry 7" = "Meta+7";
        "activate task manager entry 8" = "Meta+8";
        "activate task manager entry 9" = "Meta+9";
        "clear-history" = "none,,Clear Clipboard History";
        "clipboard_action" = "Meta+Ctrl+X";
        "cycle-panels" = "Meta+Alt+P";
        "cycleNextAction" = "none,,Next History Item";
        "cyclePrevAction" = "none,,Previous History Item";
        "edit_clipboard" = [ ];
        "manage activities" = "Meta+Q";
        "next activity" = "Meta+Tab,none,Walk through activities";
        "previous activity" = "Meta+Shift+Tab,none,Walk through activities (Reverse)";
        "repeat_action" = "Meta+Ctrl+R";
        "show dashboard" = "Ctrl+F12";
        "show-barcode" = "none,,Show Barcode…";
        "show-on-mouse-pos" = "Meta+V";
        "stop current activity" = "Meta+S";
        "switch to next activity" = "none,,Switch to Next Activity";
        "switch to previous activity" = "none,,Switch to Previous Activity";
        "toggle do not disturb" = "none,,Toggle do not disturb";
        };

      "services/org.kde.spectacle.desktop" ={
        "ActiveWindowScreenShot" = [ ];
        "FullScreenScreenShot" = [ ];
        "RecordRegion" = [ ];
        "RecordScreen" = [ ];
        "RecordWindow" = [ ];
        "RectangularRegionScreenShot" = [ ];
        "WindowUnderCursorScreenShot" = [ ];
        "_launch" = [ ];
        };
   };

    configFile = {
      "baloofilerc"."General" =
        {"dbVersion" = 2;
        "exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.venv,venv,core-dumps,lost+found";
        "exclude filters version" = 8;
        };
        "dolphinrc" = {
          "ExtractDialog" = {"2 screens: Height" = 560; "2 screens: Width" = 1024; "DirHistory[$e]" = "/Volume/@Repo/";};

          "General"."ViewPropsTimestamp" = "2024,2,26,20,37,22.221";

          "KFileDialog Settings"={
            "Places Icons Auto-resize" = false;
            "Places Icons Static Size" = 22;
            "detailViewIconSize" = 16;
            };
          "PreviewSettings"."Plugins" = "cursorthumbnail,windowsimagethumbnail,imagethumbnail,djvuthumbnail,windowsexethumbnail,jpegthumbnail,appimagethumbnail,exrthumbnail,audiothumbnail,comicbookthumbnail,kraorathumbnail,opendocumentthumbnail,directorythumbnail,ebookthumbnail,svgthumbnail,fontthumbnail,ffmpegthumbs,rawthumbnail,mltpreview,blenderthumbnail,mobithumbnail,gsthumbnail";
          "VersionControl"."enabledPlugins" = "Git";
          };
      "kactivitymanagerdrc"={
        "activities"."9dcd47d6-8787-4dd4-b599-405921c53662" = "Default";
        "main"."currentActivity" = "9dcd47d6-8787-4dd4-b599-405921c53662";
        };
      "kcminputrc"={
        "Libinput/2/7/SynPS\\/2 Synaptics TouchPad"."TapToClick" = true;
        "Tmp"."update_info" = "delete_cursor_old_default_size.upd:DeleteCursorOldDefaultSize";
        };
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"={
        "DirSelect Dialog"."DirSelectDialog Size" = "884,576";
        "KDE"."ShowDeleteCommand" = true;
        "KFileDialog Settings"={
          "Allow Expansion" = false;
          "Automatically select filename extension" = true;
          "Breadcrumb Navigation" = true;
          "Decoration position" = 2;
          "LocationCombo Completionmode" = 5;
          "PathCombo Completionmode" = 5;
          "Show Bookmarks" = false;
          "Show Full Path" = false;
          "Show Inline Previews" = true;
          "Show Preview" = false;
          "Show Speedbar" = true;
          "Show hidden files" = false;
          "Sort by" = "Name";
          "Sort directories first" = true;
          "Sort hidden files last" = false;
          "Sort reversed" = false;
          "Speedbar Width" = 138;
          "View Style" = "DetailTree";
          };
        "PreviewSettings"."MaximumRemoteSize" = 0;
        "WM"={
          "activeBackground" = "49,54,59";
          "activeBlend" = "252,252,252";
          "activeForeground" = "252,252,252";
          "inactiveBackground" = "42,46,50";
          "inactiveBlend" = "161,169,177";
          "inactiveForeground" = "161,169,177";
          };
        };
      "khotkeysrc"={
        "Data"."DataCount" = 3;
        "Data_1"={
          "Comment" = "KMenuEdit Global Shortcuts";
          "DataCount" = 1;
          "Enabled" = true;
          "Name" = "KMenuEdit";
          "SystemGroup" = 1;
          "Type" = "ACTION_DATA_GROUP";
          };
        "Data_1Conditions"={"Comment" = ""; "ConditionsCount" = 0;};

        "Data_1_1"={"Comment" = "Comment"; "Enabled" = true; "Name" = "Search"; "Type" = "SIMPLE_ACTION_DATA";};
        "Data_1_1Actions"."ActionsCount" = 1;
        "Data_1_1Actions0"={"CommandURL" = "http://google.com"; "Type" = "COMMAND_URL";};
        "Data_1_1Conditions"={"Comment" = ""; "ConditionsCount" = 0;};
        "Data_1_1Triggers"={"Comment" = "Simple_action"; "TriggersCount" = 1;};
        "Data_1_1Triggers0"={"Key" = ""; "Type" = "SHORTCUT"; "Uuid" = "{d03619b6-9b3c-48cc-9d9c-a2aadb485550}";};

        "Data_2"."Comment" = "This group contains various examples demonstrating most of the features of KHotkeys. (Note that this group and all its actions are disabled by default.)";
        "Data_2"."DataCount" = 8;
        "Data_2"."Enabled" = false;
        "Data_2"."ImportId" = "kde32b1";
        "Data_2"."Name" = "Examples";
        "Data_2"."SystemGroup" = 0;
        "Data_2"."Type" = "ACTION_DATA_GROUP";
        "Data_2Conditions"."Comment" = "";
        "Data_2Conditions"."ConditionsCount" = 0;
        "Data_2_1"."Comment" = "After pressing Ctrl+Alt+I, the KSIRC window will be activated, if it exists. Simple.";
        "Data_2_1"."Enabled" = false;
        "Data_2_1"."Name" = "Activate KSIRC Window";
        "Data_2_1"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_1Actions"."ActionsCount" = 1;
        "Data_2_1Actions0"."Type" = "ACTIVATE_WINDOW";
        "Data_2_1Actions0Window"."Comment" = "KSIRC window";
        "Data_2_1Actions0Window"."WindowsCount" = 1;
        "Data_2_1Actions0Window0"."Class" = "ksirc";
        "Data_2_1Actions0Window0"."ClassType" = 1;
        "Data_2_1Actions0Window0"."Comment" = "KSIRC";
        "Data_2_1Actions0Window0"."Role" = "";
        "Data_2_1Actions0Window0"."RoleType" = 0;
        "Data_2_1Actions0Window0"."Title" = "";
        "Data_2_1Actions0Window0"."TitleType" = 0;
        "Data_2_1Actions0Window0"."Type" = "SIMPLE";
        "Data_2_1Actions0Window0"."WindowTypes" = 33;
        "Data_2_1Conditions"."Comment" = "";
        "Data_2_1Conditions"."ConditionsCount" = 0;
        "Data_2_1Triggers"."Comment" = "Simple_action";
        "Data_2_1Triggers"."TriggersCount" = 1;
        "Data_2_1Triggers0"."Key" = "Ctrl+Alt+I";
        "Data_2_1Triggers0"."Type" = "SHORTCUT";
        "Data_2_1Triggers0"."Uuid" = "{f4fd7b05-1c0c-4281-8758-6b0c78939dfc}";
        "Data_2_2"."Comment" = "After pressing Alt+Ctrl+H the input of 'Hello' will be simulated, as if you typed it.  This is especially useful if you have call to frequently type a word (for instance, 'unsigned').  Every keypress in the input is separated by a colon ':'. Note that the keypresses literally mean keypresses, so you have to write what you would press on the keyboard. In the table below, the left column shows the input and the right column shows what to type.\n\n\"enter\" (i.e. new line)                Enter or Return\na (i.e. small a)                          A\nA (i.e. capital a)                       Shift+A\n: (colon)                                  Shift+;\n' '  (space)                              Space";
        "Data_2_2"."Enabled" = false;
        "Data_2_2"."Name" = "Type 'Hello'";
        "Data_2_2"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_2Actions"."ActionsCount" = 1;
        "Data_2_2Actions0"."DestinationWindow" = 2;
        "Data_2_2Actions0"."Input" = "Shift+H:E:L:L:O\n";
        "Data_2_2Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_2_2Conditions"."Comment" = "";
        "Data_2_2Conditions"."ConditionsCount" = 0;
        "Data_2_2Triggers"."Comment" = "Simple_action";
        "Data_2_2Triggers"."TriggersCount" = 1;
        "Data_2_2Triggers0"."Key" = "Ctrl+Alt+H";
        "Data_2_2Triggers0"."Type" = "SHORTCUT";
        "Data_2_2Triggers0"."Uuid" = "{112c4481-e000-4b18-a310-7ef9913dbc2b}";
        "Data_2_3"."Comment" = "This action runs Konsole, after pressing Ctrl+Alt+T.";
        "Data_2_3"."Enabled" = false;
        "Data_2_3"."Name" = "Run Konsole";
        "Data_2_3"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_3Actions"."ActionsCount" = 1;
        "Data_2_3Actions0"."CommandURL" = "konsole";
        "Data_2_3Actions0"."Type" = "COMMAND_URL";
        "Data_2_3Conditions"."Comment" = "";
        "Data_2_3Conditions"."ConditionsCount" = 0;
        "Data_2_3Triggers"."Comment" = "Simple_action";
        "Data_2_3Triggers"."TriggersCount" = 1;
        "Data_2_3Triggers0"."Key" = "Ctrl+Alt+T";
        "Data_2_3Triggers0"."Type" = "SHORTCUT";
        "Data_2_3Triggers0"."Uuid" = "{456392a5-6e00-4a7e-81a5-bad38f8d7b4f}";
        "Data_2_4"."Comment" = "Read the comment on the \"Type 'Hello'\" action first.\n\nQt Designer uses Ctrl+F4 for closing windows.  In KDE, however, Ctrl+F4 is the shortcut for going to virtual desktop 4, so this shortcut does not work in Qt Designer.  Further, Qt Designer does not use KDE's standard Ctrl+W for closing the window.\n\nThis problem can be solved by remapping Ctrl+W to Ctrl+F4 when the active window is Qt Designer. When Qt Designer is active, every time Ctrl+W is pressed, Ctrl+F4 will be sent to Qt Designer instead. In other applications, the effect of Ctrl+W is unchanged.\n\nWe now need to specify three things: A new shortcut trigger on 'Ctrl+W', a new keyboard input action sending Ctrl+F4, and a new condition that the active window is Qt Designer.\nQt Designer seems to always have title 'Qt Designer by Trolltech', so the condition will check for the active window having that title.";
        "Data_2_4"."Enabled" = false;
        "Data_2_4"."Name" = "Remap Ctrl+W to Ctrl+F4 in Qt Designer";
        "Data_2_4"."Type" = "GENERIC_ACTION_DATA";
        "Data_2_4Actions"."ActionsCount" = 1;
        "Data_2_4Actions0"."DestinationWindow" = 2;
        "Data_2_4Actions0"."Input" = "Ctrl+F4";
        "Data_2_4Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_2_4Conditions"."Comment" = "";
        "Data_2_4Conditions"."ConditionsCount" = 1;
        "Data_2_4Conditions0"."Type" = "ACTIVE_WINDOW";
        "Data_2_4Conditions0Window"."Comment" = "Qt Designer";
        "Data_2_4Conditions0Window"."WindowsCount" = 1;
        "Data_2_4Conditions0Window0"."Class" = "";
        "Data_2_4Conditions0Window0"."ClassType" = 0;
        "Data_2_4Conditions0Window0"."Comment" = "";
        "Data_2_4Conditions0Window0"."Role" = "";
        "Data_2_4Conditions0Window0"."RoleType" = 0;
        "Data_2_4Conditions0Window0"."Title" = "Qt Designer by Trolltech";
        "Data_2_4Conditions0Window0"."TitleType" = 2;
        "Data_2_4Conditions0Window0"."Type" = "SIMPLE";
        "Data_2_4Conditions0Window0"."WindowTypes" = 33;
        "Data_2_4Triggers"."Comment" = "";
        "Data_2_4Triggers"."TriggersCount" = 1;
        "Data_2_4Triggers0"."Key" = "Ctrl+W";
        "Data_2_4Triggers0"."Type" = "SHORTCUT";
        "Data_2_4Triggers0"."Uuid" = "{6e009d6a-a0ec-46df-b011-61f8fe0b154d}";
        "Data_2_5"."Comment" = "By pressing Alt+Ctrl+W a D-Bus call will be performed that will show the minicli. You can use any kind of D-Bus call, just like using the command line 'qdbus' tool.";
        "Data_2_5"."Enabled" = false;
        "Data_2_5"."Name" = "Perform D-Bus call 'qdbus org.kde.krunner /App display'";
        "Data_2_5"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_5Actions"."ActionsCount" = 1;
        "Data_2_5Actions0"."Arguments" = "";
        "Data_2_5Actions0"."Call" = "popupExecuteCommand";
        "Data_2_5Actions0"."RemoteApp" = "org.kde.krunner";
        "Data_2_5Actions0"."RemoteObj" = "/App";
        "Data_2_5Actions0"."Type" = "DBUS";
        "Data_2_5Conditions"."Comment" = "";
        "Data_2_5Conditions"."ConditionsCount" = 0;
        "Data_2_5Triggers"."Comment" = "Simple_action";
        "Data_2_5Triggers"."TriggersCount" = 1;
        "Data_2_5Triggers0"."Key" = "Ctrl+Alt+W";
        "Data_2_5Triggers0"."Type" = "SHORTCUT";
        "Data_2_5Triggers0"."Uuid" = "{91261ce1-2182-402b-8dc4-c9727a493d90}";
        "Data_2_6"."Comment" = "Read the comment on the \"Type 'Hello'\" action first.\n\nJust like the \"Type 'Hello'\" action, this one simulates keyboard input, specifically, after pressing Ctrl+Alt+B, it sends B to XMMS (B in XMMS jumps to the next song). The 'Send to specific window' checkbox is checked and a window with its class containing 'XMMS_Player' is specified; this will make the input always be sent to this window. This way, you can control XMMS even if, for instance, it is on a different virtual desktop.\n\n(Run 'xprop' and click on the XMMS window and search for WM_CLASS to see 'XMMS_Player').";
        "Data_2_6"."Enabled" = false;
        "Data_2_6"."Name" = "Next in XMMS";
        "Data_2_6"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_6Actions"."ActionsCount" = 1;
        "Data_2_6Actions0"."DestinationWindow" = 1;
        "Data_2_6Actions0"."Input" = "B";
        "Data_2_6Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_2_6Actions0DestinationWindow"."Comment" = "XMMS window";
        "Data_2_6Actions0DestinationWindow"."WindowsCount" = 1;
        "Data_2_6Actions0DestinationWindow0"."Class" = "XMMS_Player";
        "Data_2_6Actions0DestinationWindow0"."ClassType" = 1;
        "Data_2_6Actions0DestinationWindow0"."Comment" = "XMMS Player window";
        "Data_2_6Actions0DestinationWindow0"."Role" = "";
        "Data_2_6Actions0DestinationWindow0"."RoleType" = 0;
        "Data_2_6Actions0DestinationWindow0"."Title" = "";
        "Data_2_6Actions0DestinationWindow0"."TitleType" = 0;
        "Data_2_6Actions0DestinationWindow0"."Type" = "SIMPLE";
        "Data_2_6Actions0DestinationWindow0"."WindowTypes" = 33;
        "Data_2_6Conditions"."Comment" = "";
        "Data_2_6Conditions"."ConditionsCount" = 0;
        "Data_2_6Triggers"."Comment" = "Simple_action";
        "Data_2_6Triggers"."TriggersCount" = 1;
        "Data_2_6Triggers0"."Key" = "Ctrl+Alt+B";
        "Data_2_6Triggers0"."Type" = "SHORTCUT";
        "Data_2_6Triggers0"."Uuid" = "{bb83a023-beb1-432a-83a2-0e7b0f7b8606}";
        "Data_2_7"."Comment" = "Konqueror in KDE3.1 has tabs, and now you can also have gestures.\n\nJust press the middle mouse button and start drawing one of the gestures, and after you are finished, release the mouse button. If you only need to paste the selection, it still works, just click the middle mouse button. (You can change the mouse button to use in the global settings).\n\nRight now, there are the following gestures available:\nmove right and back left - Forward (Alt+Right)\nmove left and back right - Back (Alt+Left)\nmove up and back down  - Up (Alt+Up)\ncircle counterclockwise - Reload (F5)\n\nThe gesture shapes can be entered by performing them in the configuration dialog. You can also look at your numeric pad to help you: gestures are recognized like a 3x3 grid of fields, numbered 1 to 9.\n\nNote that you must perform exactly the gesture to trigger the action. Because of this, it is possible to enter more gestures for the action. You should try to avoid complicated gestures where you change the direction of mouse movement more than once.  For instance, 45654 or 74123 are simple to perform, but 1236987 may be already quite difficult.\n\nThe conditions for all gestures are defined in this group. All these gestures are active only if the active window is Konqueror (class contains 'konqueror').";
        "Data_2_7"."DataCount" = 4;
        "Data_2_7"."Enabled" = false;
        "Data_2_7"."Name" = "Konqi Gestures";
        "Data_2_7"."SystemGroup" = 0;
        "Data_2_7"."Type" = "ACTION_DATA_GROUP";
        "Data_2_7Conditions"."Comment" = "Konqueror window";
        "Data_2_7Conditions"."ConditionsCount" = 1;
        "Data_2_7Conditions0"."Type" = "ACTIVE_WINDOW";
        "Data_2_7Conditions0Window"."Comment" = "Konqueror";
        "Data_2_7Conditions0Window"."WindowsCount" = 1;
        "Data_2_7Conditions0Window0"."Class" = "konqueror";
        "Data_2_7Conditions0Window0"."ClassType" = 1;
        "Data_2_7Conditions0Window0"."Comment" = "Konqueror";
        "Data_2_7Conditions0Window0"."Role" = "";
        "Data_2_7Conditions0Window0"."RoleType" = 0;
        "Data_2_7Conditions0Window0"."Title" = "";
        "Data_2_7Conditions0Window0"."TitleType" = 0;
        "Data_2_7Conditions0Window0"."Type" = "SIMPLE";
        "Data_2_7Conditions0Window0"."WindowTypes" = 33;
        "Data_2_7_1"."Comment" = "";
        "Data_2_7_1"."Enabled" = false;
        "Data_2_7_1"."Name" = "Back";
        "Data_2_7_1"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_7_1Actions"."ActionsCount" = 1;
        "Data_2_7_1Actions0"."DestinationWindow" = 2;
        "Data_2_7_1Actions0"."Input" = "Alt+Left";
        "Data_2_7_1Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_2_7_1Conditions"."Comment" = "";
        "Data_2_7_1Conditions"."ConditionsCount" = 0;
        "Data_2_7_1Triggers"."Comment" = "Gesture_triggers";
        "Data_2_7_1Triggers"."TriggersCount" = 3;
        "Data_2_7_1Triggers0"."GesturePointData" = "0,0.0625,1,1,0.5,0.0625,0.0625,1,0.875,0.5,0.125,0.0625,1,0.75,0.5,0.1875,0.0625,1,0.625,0.5,0.25,0.0625,1,0.5,0.5,0.3125,0.0625,1,0.375,0.5,0.375,0.0625,1,0.25,0.5,0.4375,0.0625,1,0.125,0.5,0.5,0.0625,0,0,0.5,0.5625,0.0625,0,0.125,0.5,0.625,0.0625,0,0.25,0.5,0.6875,0.0625,0,0.375,0.5,0.75,0.0625,0,0.5,0.5,0.8125,0.0625,0,0.625,0.5,0.875,0.0625,0,0.75,0.5,0.9375,0.0625,0,0.875,0.5,1,0,0,1,0.5";
        "Data_2_7_1Triggers0"."Type" = "GESTURE";
        "Data_2_7_1Triggers1"."GesturePointData" = "0,0.0833333,1,0.5,0.5,0.0833333,0.0833333,1,0.375,0.5,0.166667,0.0833333,1,0.25,0.5,0.25,0.0833333,1,0.125,0.5,0.333333,0.0833333,0,0,0.5,0.416667,0.0833333,0,0.125,0.5,0.5,0.0833333,0,0.25,0.5,0.583333,0.0833333,0,0.375,0.5,0.666667,0.0833333,0,0.5,0.5,0.75,0.0833333,0,0.625,0.5,0.833333,0.0833333,0,0.75,0.5,0.916667,0.0833333,0,0.875,0.5,1,0,0,1,0.5";
        "Data_2_7_1Triggers1"."Type" = "GESTURE";
        "Data_2_7_1Triggers2"."GesturePointData" = "0,0.0833333,1,1,0.5,0.0833333,0.0833333,1,0.875,0.5,0.166667,0.0833333,1,0.75,0.5,0.25,0.0833333,1,0.625,0.5,0.333333,0.0833333,1,0.5,0.5,0.416667,0.0833333,1,0.375,0.5,0.5,0.0833333,1,0.25,0.5,0.583333,0.0833333,1,0.125,0.5,0.666667,0.0833333,0,0,0.5,0.75,0.0833333,0,0.125,0.5,0.833333,0.0833333,0,0.25,0.5,0.916667,0.0833333,0,0.375,0.5,1,0,0,0.5,0.5";
        "Data_2_7_1Triggers2"."Type" = "GESTURE";
        "Data_2_7_2"."Comment" = "";
        "Data_2_7_2"."Enabled" = false;
        "Data_2_7_2"."Name" = "Forward";
        "Data_2_7_2"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_7_2Actions"."ActionsCount" = 1;
        "Data_2_7_2Actions0"."DestinationWindow" = 2;
        "Data_2_7_2Actions0"."Input" = "Alt+Right";
        "Data_2_7_2Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_2_7_2Conditions"."Comment" = "";
        "Data_2_7_2Conditions"."ConditionsCount" = 0;
        "Data_2_7_2Triggers"."Comment" = "Gesture_triggers";
        "Data_2_7_2Triggers"."TriggersCount" = 3;
        "Data_2_7_2Triggers0"."GesturePointData" = "0,0.0625,0,0,0.5,0.0625,0.0625,0,0.125,0.5,0.125,0.0625,0,0.25,0.5,0.1875,0.0625,0,0.375,0.5,0.25,0.0625,0,0.5,0.5,0.3125,0.0625,0,0.625,0.5,0.375,0.0625,0,0.75,0.5,0.4375,0.0625,0,0.875,0.5,0.5,0.0625,1,1,0.5,0.5625,0.0625,1,0.875,0.5,0.625,0.0625,1,0.75,0.5,0.6875,0.0625,1,0.625,0.5,0.75,0.0625,1,0.5,0.5,0.8125,0.0625,1,0.375,0.5,0.875,0.0625,1,0.25,0.5,0.9375,0.0625,1,0.125,0.5,1,0,0,0,0.5";
        "Data_2_7_2Triggers0"."Type" = "GESTURE";
        "Data_2_7_2Triggers1"."GesturePointData" = "0,0.0833333,0,0.5,0.5,0.0833333,0.0833333,0,0.625,0.5,0.166667,0.0833333,0,0.75,0.5,0.25,0.0833333,0,0.875,0.5,0.333333,0.0833333,1,1,0.5,0.416667,0.0833333,1,0.875,0.5,0.5,0.0833333,1,0.75,0.5,0.583333,0.0833333,1,0.625,0.5,0.666667,0.0833333,1,0.5,0.5,0.75,0.0833333,1,0.375,0.5,0.833333,0.0833333,1,0.25,0.5,0.916667,0.0833333,1,0.125,0.5,1,0,0,0,0.5";
        "Data_2_7_2Triggers1"."Type" = "GESTURE";
        "Data_2_7_2Triggers2"."GesturePointData" = "0,0.0833333,0,0,0.5,0.0833333,0.0833333,0,0.125,0.5,0.166667,0.0833333,0,0.25,0.5,0.25,0.0833333,0,0.375,0.5,0.333333,0.0833333,0,0.5,0.5,0.416667,0.0833333,0,0.625,0.5,0.5,0.0833333,0,0.75,0.5,0.583333,0.0833333,0,0.875,0.5,0.666667,0.0833333,1,1,0.5,0.75,0.0833333,1,0.875,0.5,0.833333,0.0833333,1,0.75,0.5,0.916667,0.0833333,1,0.625,0.5,1,0,0,0.5,0.5";
        "Data_2_7_2Triggers2"."Type" = "GESTURE";
        "Data_2_7_3"."Comment" = "";
        "Data_2_7_3"."Enabled" = false;
        "Data_2_7_3"."Name" = "Up";
        "Data_2_7_3"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_7_3Actions"."ActionsCount" = 1;
        "Data_2_7_3Actions0"."DestinationWindow" = 2;
        "Data_2_7_3Actions0"."Input" = "Alt+Up";
        "Data_2_7_3Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_2_7_3Conditions"."Comment" = "";
        "Data_2_7_3Conditions"."ConditionsCount" = 0;
        "Data_2_7_3Triggers"."Comment" = "Gesture_triggers";
        "Data_2_7_3Triggers"."TriggersCount" = 3;
        "Data_2_7_3Triggers0"."GesturePointData" = "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
        "Data_2_7_3Triggers0"."Type" = "GESTURE";
        "Data_2_7_3Triggers1"."GesturePointData" = "0,0.0833333,-0.5,0.5,1,0.0833333,0.0833333,-0.5,0.5,0.875,0.166667,0.0833333,-0.5,0.5,0.75,0.25,0.0833333,-0.5,0.5,0.625,0.333333,0.0833333,-0.5,0.5,0.5,0.416667,0.0833333,-0.5,0.5,0.375,0.5,0.0833333,-0.5,0.5,0.25,0.583333,0.0833333,-0.5,0.5,0.125,0.666667,0.0833333,0.5,0.5,0,0.75,0.0833333,0.5,0.5,0.125,0.833333,0.0833333,0.5,0.5,0.25,0.916667,0.0833333,0.5,0.5,0.375,1,0,0,0.5,0.5";
        "Data_2_7_3Triggers1"."Type" = "GESTURE";
        "Data_2_7_3Triggers2"."GesturePointData" = "0,0.0833333,-0.5,0.5,0.5,0.0833333,0.0833333,-0.5,0.5,0.375,0.166667,0.0833333,-0.5,0.5,0.25,0.25,0.0833333,-0.5,0.5,0.125,0.333333,0.0833333,0.5,0.5,0,0.416667,0.0833333,0.5,0.5,0.125,0.5,0.0833333,0.5,0.5,0.25,0.583333,0.0833333,0.5,0.5,0.375,0.666667,0.0833333,0.5,0.5,0.5,0.75,0.0833333,0.5,0.5,0.625,0.833333,0.0833333,0.5,0.5,0.75,0.916667,0.0833333,0.5,0.5,0.875,1,0,0,0.5,1";
        "Data_2_7_3Triggers2"."Type" = "GESTURE";
        "Data_2_7_4"."Comment" = "";
        "Data_2_7_4"."Enabled" = false;
        "Data_2_7_4"."Name" = "Reload";
        "Data_2_7_4"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_7_4Actions"."ActionsCount" = 1;
        "Data_2_7_4Actions0"."DestinationWindow" = 2;
        "Data_2_7_4Actions0"."Input" = "F5";
        "Data_2_7_4Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_2_7_4Conditions"."Comment" = "";
        "Data_2_7_4Conditions"."ConditionsCount" = 0;
        "Data_2_7_4Triggers"."Comment" = "Gesture_triggers";
        "Data_2_7_4Triggers"."TriggersCount" = 3;
        "Data_2_7_4Triggers0"."GesturePointData" = "0,0.03125,0,0,1,0.03125,0.03125,0,0.125,1,0.0625,0.03125,0,0.25,1,0.09375,0.03125,0,0.375,1,0.125,0.03125,0,0.5,1,0.15625,0.03125,0,0.625,1,0.1875,0.03125,0,0.75,1,0.21875,0.03125,0,0.875,1,0.25,0.03125,-0.5,1,1,0.28125,0.03125,-0.5,1,0.875,0.3125,0.03125,-0.5,1,0.75,0.34375,0.03125,-0.5,1,0.625,0.375,0.03125,-0.5,1,0.5,0.40625,0.03125,-0.5,1,0.375,0.4375,0.03125,-0.5,1,0.25,0.46875,0.03125,-0.5,1,0.125,0.5,0.03125,1,1,0,0.53125,0.03125,1,0.875,0,0.5625,0.03125,1,0.75,0,0.59375,0.03125,1,0.625,0,0.625,0.03125,1,0.5,0,0.65625,0.03125,1,0.375,0,0.6875,0.03125,1,0.25,0,0.71875,0.03125,1,0.125,0,0.75,0.03125,0.5,0,0,0.78125,0.03125,0.5,0,0.125,0.8125,0.03125,0.5,0,0.25,0.84375,0.03125,0.5,0,0.375,0.875,0.03125,0.5,0,0.5,0.90625,0.03125,0.5,0,0.625,0.9375,0.03125,0.5,0,0.75,0.96875,0.03125,0.5,0,0.875,1,0,0,0,1";
        "Data_2_7_4Triggers0"."Type" = "GESTURE";
        "Data_2_7_4Triggers1"."GesturePointData" = "0,0.0277778,0,0,1,0.0277778,0.0277778,0,0.125,1,0.0555556,0.0277778,0,0.25,1,0.0833333,0.0277778,0,0.375,1,0.111111,0.0277778,0,0.5,1,0.138889,0.0277778,0,0.625,1,0.166667,0.0277778,0,0.75,1,0.194444,0.0277778,0,0.875,1,0.222222,0.0277778,-0.5,1,1,0.25,0.0277778,-0.5,1,0.875,0.277778,0.0277778,-0.5,1,0.75,0.305556,0.0277778,-0.5,1,0.625,0.333333,0.0277778,-0.5,1,0.5,0.361111,0.0277778,-0.5,1,0.375,0.388889,0.0277778,-0.5,1,0.25,0.416667,0.0277778,-0.5,1,0.125,0.444444,0.0277778,1,1,0,0.472222,0.0277778,1,0.875,0,0.5,0.0277778,1,0.75,0,0.527778,0.0277778,1,0.625,0,0.555556,0.0277778,1,0.5,0,0.583333,0.0277778,1,0.375,0,0.611111,0.0277778,1,0.25,0,0.638889,0.0277778,1,0.125,0,0.666667,0.0277778,0.5,0,0,0.694444,0.0277778,0.5,0,0.125,0.722222,0.0277778,0.5,0,0.25,0.75,0.0277778,0.5,0,0.375,0.777778,0.0277778,0.5,0,0.5,0.805556,0.0277778,0.5,0,0.625,0.833333,0.0277778,0.5,0,0.75,0.861111,0.0277778,0.5,0,0.875,0.888889,0.0277778,0,0,1,0.916667,0.0277778,0,0.125,1,0.944444,0.0277778,0,0.25,1,0.972222,0.0277778,0,0.375,1,1,0,0,0.5,1";
        "Data_2_7_4Triggers1"."Type" = "GESTURE";
        "Data_2_7_4Triggers2"."GesturePointData" = "0,0.0277778,0.5,0,0.5,0.0277778,0.0277778,0.5,0,0.625,0.0555556,0.0277778,0.5,0,0.75,0.0833333,0.0277778,0.5,0,0.875,0.111111,0.0277778,0,0,1,0.138889,0.0277778,0,0.125,1,0.166667,0.0277778,0,0.25,1,0.194444,0.0277778,0,0.375,1,0.222222,0.0277778,0,0.5,1,0.25,0.0277778,0,0.625,1,0.277778,0.0277778,0,0.75,1,0.305556,0.0277778,0,0.875,1,0.333333,0.0277778,-0.5,1,1,0.361111,0.0277778,-0.5,1,0.875,0.388889,0.0277778,-0.5,1,0.75,0.416667,0.0277778,-0.5,1,0.625,0.444444,0.0277778,-0.5,1,0.5,0.472222,0.0277778,-0.5,1,0.375,0.5,0.0277778,-0.5,1,0.25,0.527778,0.0277778,-0.5,1,0.125,0.555556,0.0277778,1,1,0,0.583333,0.0277778,1,0.875,0,0.611111,0.0277778,1,0.75,0,0.638889,0.0277778,1,0.625,0,0.666667,0.0277778,1,0.5,0,0.694444,0.0277778,1,0.375,0,0.722222,0.0277778,1,0.25,0,0.75,0.0277778,1,0.125,0,0.777778,0.0277778,0.5,0,0,0.805556,0.0277778,0.5,0,0.125,0.833333,0.0277778,0.5,0,0.25,0.861111,0.0277778,0.5,0,0.375,0.888889,0.0277778,0.5,0,0.5,0.916667,0.0277778,0.5,0,0.625,0.944444,0.0277778,0.5,0,0.75,0.972222,0.0277778,0.5,0,0.875,1,0,0,0,1";
        "Data_2_7_4Triggers2"."Type" = "GESTURE";
        "Data_2_8"."Comment" = "After pressing Win+E (Tux+E) a WWW browser will be launched, and it will open http://www.kde.org . You may run all kind of commands you can run in minicli (Alt+F2).";
        "Data_2_8"."Enabled" = false;
        "Data_2_8"."Name" = "Go to KDE Website";
        "Data_2_8"."Type" = "SIMPLE_ACTION_DATA";
        "Data_2_8Actions"."ActionsCount" = 1;
        "Data_2_8Actions0"."CommandURL" = "http://www.kde.org";
        "Data_2_8Actions0"."Type" = "COMMAND_URL";
        "Data_2_8Conditions"."Comment" = "";
        "Data_2_8Conditions"."ConditionsCount" = 0;
        "Data_2_8Triggers"."Comment" = "Simple_action";
        "Data_2_8Triggers"."TriggersCount" = 1;
        "Data_2_8Triggers0"."Key" = "Meta+E";
        "Data_2_8Triggers0"."Type" = "SHORTCUT";
        "Data_2_8Triggers0"."Uuid" = "{d7f78599-46a3-4300-8ec2-2c4304e87c41}";
        "Data_3"."Comment" = "Basic Konqueror gestures.";
        "Data_3"."DataCount" = 14;
        "Data_3"."Enabled" = true;
        "Data_3"."ImportId" = "konqueror_gestures_kde321";
        "Data_3"."Name" = "Konqueror Gestures";
        "Data_3"."SystemGroup" = 0;
        "Data_3"."Type" = "ACTION_DATA_GROUP";
        "Data_3Conditions"."Comment" = "Konqueror window";
        "Data_3Conditions"."ConditionsCount" = 1;
        "Data_3Conditions0"."Type" = "ACTIVE_WINDOW";
        "Data_3Conditions0Window"."Comment" = "Konqueror";
        "Data_3Conditions0Window"."WindowsCount" = 1;
        "Data_3Conditions0Window0"."Class" = "^konqueror\s";
        "Data_3Conditions0Window0"."ClassType" = 3;
        "Data_3Conditions0Window0"."Comment" = "Konqueror";
        "Data_3Conditions0Window0"."Role" = "konqueror-mainwindow#1";
        "Data_3Conditions0Window0"."RoleType" = 0;
        "Data_3Conditions0Window0"."Title" = "file:/ - Konqueror";
        "Data_3Conditions0Window0"."TitleType" = 0;
        "Data_3Conditions0Window0"."Type" = "SIMPLE";
        "Data_3Conditions0Window0"."WindowTypes" = 1;
        "Data_3_1"."Comment" = "Press, move left, release.";
        "Data_3_1"."Enabled" = true;
        "Data_3_1"."Name" = "Back";
        "Data_3_1"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_10"."Comment" = "Opera-style: Press, move up, release.\nNOTE: Conflicts with 'New Tab', and as such is disabled by default.";
        "Data_3_10"."Enabled" = false;
        "Data_3_10"."Name" = "Stop Loading";
        "Data_3_10"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_10Actions"."ActionsCount" = 1;
        "Data_3_10Actions0"."DestinationWindow" = 2;
        "Data_3_10Actions0"."Input" = "Escape\n";
        "Data_3_10Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_10Conditions"."Comment" = "";
        "Data_3_10Conditions"."ConditionsCount" = 0;
        "Data_3_10Triggers"."Comment" = "Gesture_triggers";
        "Data_3_10Triggers"."TriggersCount" = 1;
        "Data_3_10Triggers0"."GesturePointData" = "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
        "Data_3_10Triggers0"."Type" = "GESTURE";
        "Data_3_11"."Comment" = "Going up in URL/directory structure.\nMozilla-style: Press, move up, move left, move up, release.";
        "Data_3_11"."Enabled" = true;
        "Data_3_11"."Name" = "Up";
        "Data_3_11"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_11Actions"."ActionsCount" = 1;
        "Data_3_11Actions0"."DestinationWindow" = 2;
        "Data_3_11Actions0"."Input" = "Alt+Up";
        "Data_3_11Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_11Conditions"."Comment" = "";
        "Data_3_11Conditions"."ConditionsCount" = 0;
        "Data_3_11Triggers"."Comment" = "Gesture_triggers";
        "Data_3_11Triggers"."TriggersCount" = 1;
        "Data_3_11Triggers0"."GesturePointData" = "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,1,1,0.5,0.3125,0.0625,1,0.875,0.5,0.375,0.0625,1,0.75,0.5,0.4375,0.0625,1,0.625,0.5,0.5,0.0625,1,0.5,0.5,0.5625,0.0625,1,0.375,0.5,0.625,0.0625,1,0.25,0.5,0.6875,0.0625,1,0.125,0.5,0.75,0.0625,-0.5,0,0.5,0.8125,0.0625,-0.5,0,0.375,0.875,0.0625,-0.5,0,0.25,0.9375,0.0625,-0.5,0,0.125,1,0,0,0,0";
        "Data_3_11Triggers0"."Type" = "GESTURE";
        "Data_3_12"."Comment" = "Going up in URL/directory structure.\nOpera-style: Press, move up, move left, move up, release.\nNOTE: Conflicts with  \"Activate Previous Tab\", and as such is disabled by default.";
        "Data_3_12"."Enabled" = false;
        "Data_3_12"."Name" = "Up #2";
        "Data_3_12"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_12Actions"."ActionsCount" = 1;
        "Data_3_12Actions0"."DestinationWindow" = 2;
        "Data_3_12Actions0"."Input" = "Alt+Up\n";
        "Data_3_12Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_12Conditions"."Comment" = "";
        "Data_3_12Conditions"."ConditionsCount" = 0;
        "Data_3_12Triggers"."Comment" = "Gesture_triggers";
        "Data_3_12Triggers"."TriggersCount" = 1;
        "Data_3_12Triggers0"."GesturePointData" = "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
        "Data_3_12Triggers0"."Type" = "GESTURE";
        "Data_3_13"."Comment" = "Press, move up, move right, release.";
        "Data_3_13"."Enabled" = true;
        "Data_3_13"."Name" = "Activate Next Tab";
        "Data_3_13"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_13Actions"."ActionsCount" = 1;
        "Data_3_13Actions0"."DestinationWindow" = 2;
        "Data_3_13Actions0"."Input" = "Ctrl+.\n";
        "Data_3_13Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_13Conditions"."Comment" = "";
        "Data_3_13Conditions"."ConditionsCount" = 0;
        "Data_3_13Triggers"."Comment" = "Gesture_triggers";
        "Data_3_13Triggers"."TriggersCount" = 1;
        "Data_3_13Triggers0"."GesturePointData" = "0,0.0625,-0.5,0,1,0.0625,0.0625,-0.5,0,0.875,0.125,0.0625,-0.5,0,0.75,0.1875,0.0625,-0.5,0,0.625,0.25,0.0625,-0.5,0,0.5,0.3125,0.0625,-0.5,0,0.375,0.375,0.0625,-0.5,0,0.25,0.4375,0.0625,-0.5,0,0.125,0.5,0.0625,0,0,0,0.5625,0.0625,0,0.125,0,0.625,0.0625,0,0.25,0,0.6875,0.0625,0,0.375,0,0.75,0.0625,0,0.5,0,0.8125,0.0625,0,0.625,0,0.875,0.0625,0,0.75,0,0.9375,0.0625,0,0.875,0,1,0,0,1,0";
        "Data_3_13Triggers0"."Type" = "GESTURE";
        "Data_3_14"."Comment" = "Press, move up, move left, release.";
        "Data_3_14"."Enabled" = true;
        "Data_3_14"."Name" = "Activate Previous Tab";
        "Data_3_14"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_14Actions"."ActionsCount" = 1;
        "Data_3_14Actions0"."DestinationWindow" = 2;
        "Data_3_14Actions0"."Input" = "Ctrl+,";
        "Data_3_14Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_14Conditions"."Comment" = "";
        "Data_3_14Conditions"."ConditionsCount" = 0;
        "Data_3_14Triggers"."Comment" = "Gesture_triggers";
        "Data_3_14Triggers"."TriggersCount" = 1;
        "Data_3_14Triggers0"."GesturePointData" = "0,0.0625,-0.5,1,1,0.0625,0.0625,-0.5,1,0.875,0.125,0.0625,-0.5,1,0.75,0.1875,0.0625,-0.5,1,0.625,0.25,0.0625,-0.5,1,0.5,0.3125,0.0625,-0.5,1,0.375,0.375,0.0625,-0.5,1,0.25,0.4375,0.0625,-0.5,1,0.125,0.5,0.0625,1,1,0,0.5625,0.0625,1,0.875,0,0.625,0.0625,1,0.75,0,0.6875,0.0625,1,0.625,0,0.75,0.0625,1,0.5,0,0.8125,0.0625,1,0.375,0,0.875,0.0625,1,0.25,0,0.9375,0.0625,1,0.125,0,1,0,0,0,0";
        "Data_3_14Triggers0"."Type" = "GESTURE";
        "Data_3_1Actions"."ActionsCount" = 1;
        "Data_3_1Actions0"."DestinationWindow" = 2;
        "Data_3_1Actions0"."Input" = "Alt+Left";
        "Data_3_1Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_1Conditions"."Comment" = "";
        "Data_3_1Conditions"."ConditionsCount" = 0;
        "Data_3_1Triggers"."Comment" = "Gesture_triggers";
        "Data_3_1Triggers"."TriggersCount" = 1;
        "Data_3_1Triggers0"."GesturePointData" = "0,0.125,1,1,0.5,0.125,0.125,1,0.875,0.5,0.25,0.125,1,0.75,0.5,0.375,0.125,1,0.625,0.5,0.5,0.125,1,0.5,0.5,0.625,0.125,1,0.375,0.5,0.75,0.125,1,0.25,0.5,0.875,0.125,1,0.125,0.5,1,0,0,0,0.5";
        "Data_3_1Triggers0"."Type" = "GESTURE";
        "Data_3_2"."Comment" = "Press, move down, move up, move down, release.";
        "Data_3_2"."Enabled" = true;
        "Data_3_2"."Name" = "Duplicate Tab";
        "Data_3_2"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_2Actions"."ActionsCount" = 1;
        "Data_3_2Actions0"."DestinationWindow" = 2;
        "Data_3_2Actions0"."Input" = "Ctrl+Shift+D\n";
        "Data_3_2Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_2Conditions"."Comment" = "";
        "Data_3_2Conditions"."ConditionsCount" = 0;
        "Data_3_2Triggers"."Comment" = "Gesture_triggers";
        "Data_3_2Triggers"."TriggersCount" = 1;
        "Data_3_2Triggers0"."GesturePointData" = "0,0.0416667,0.5,0.5,0,0.0416667,0.0416667,0.5,0.5,0.125,0.0833333,0.0416667,0.5,0.5,0.25,0.125,0.0416667,0.5,0.5,0.375,0.166667,0.0416667,0.5,0.5,0.5,0.208333,0.0416667,0.5,0.5,0.625,0.25,0.0416667,0.5,0.5,0.75,0.291667,0.0416667,0.5,0.5,0.875,0.333333,0.0416667,-0.5,0.5,1,0.375,0.0416667,-0.5,0.5,0.875,0.416667,0.0416667,-0.5,0.5,0.75,0.458333,0.0416667,-0.5,0.5,0.625,0.5,0.0416667,-0.5,0.5,0.5,0.541667,0.0416667,-0.5,0.5,0.375,0.583333,0.0416667,-0.5,0.5,0.25,0.625,0.0416667,-0.5,0.5,0.125,0.666667,0.0416667,0.5,0.5,0,0.708333,0.0416667,0.5,0.5,0.125,0.75,0.0416667,0.5,0.5,0.25,0.791667,0.0416667,0.5,0.5,0.375,0.833333,0.0416667,0.5,0.5,0.5,0.875,0.0416667,0.5,0.5,0.625,0.916667,0.0416667,0.5,0.5,0.75,0.958333,0.0416667,0.5,0.5,0.875,1,0,0,0.5,1";
        "Data_3_2Triggers0"."Type" = "GESTURE";
        "Data_3_3"."Comment" = "Press, move down, move up, release.";
        "Data_3_3"."Enabled" = true;
        "Data_3_3"."Name" = "Duplicate Window";
        "Data_3_3"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_3Actions"."ActionsCount" = 1;
        "Data_3_3Actions0"."DestinationWindow" = 2;
        "Data_3_3Actions0"."Input" = "Ctrl+D\n";
        "Data_3_3Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_3Conditions"."Comment" = "";
        "Data_3_3Conditions"."ConditionsCount" = 0;
        "Data_3_3Triggers"."Comment" = "Gesture_triggers";
        "Data_3_3Triggers"."TriggersCount" = 1;
        "Data_3_3Triggers0"."GesturePointData" = "0,0.0625,0.5,0.5,0,0.0625,0.0625,0.5,0.5,0.125,0.125,0.0625,0.5,0.5,0.25,0.1875,0.0625,0.5,0.5,0.375,0.25,0.0625,0.5,0.5,0.5,0.3125,0.0625,0.5,0.5,0.625,0.375,0.0625,0.5,0.5,0.75,0.4375,0.0625,0.5,0.5,0.875,0.5,0.0625,-0.5,0.5,1,0.5625,0.0625,-0.5,0.5,0.875,0.625,0.0625,-0.5,0.5,0.75,0.6875,0.0625,-0.5,0.5,0.625,0.75,0.0625,-0.5,0.5,0.5,0.8125,0.0625,-0.5,0.5,0.375,0.875,0.0625,-0.5,0.5,0.25,0.9375,0.0625,-0.5,0.5,0.125,1,0,0,0.5,0";
        "Data_3_3Triggers0"."Type" = "GESTURE";
        "Data_3_4"."Comment" = "Press, move right, release.";
        "Data_3_4"."Enabled" = true;
        "Data_3_4"."Name" = "Forward";
        "Data_3_4"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_4Actions"."ActionsCount" = 1;
        "Data_3_4Actions0"."DestinationWindow" = 2;
        "Data_3_4Actions0"."Input" = "Alt+Right";
        "Data_3_4Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_4Conditions"."Comment" = "";
        "Data_3_4Conditions"."ConditionsCount" = 0;
        "Data_3_4Triggers"."Comment" = "Gesture_triggers";
        "Data_3_4Triggers"."TriggersCount" = 1;
        "Data_3_4Triggers0"."GesturePointData" = "0,0.125,0,0,0.5,0.125,0.125,0,0.125,0.5,0.25,0.125,0,0.25,0.5,0.375,0.125,0,0.375,0.5,0.5,0.125,0,0.5,0.5,0.625,0.125,0,0.625,0.5,0.75,0.125,0,0.75,0.5,0.875,0.125,0,0.875,0.5,1,0,0,1,0.5";
        "Data_3_4Triggers0"."Type" = "GESTURE";
        "Data_3_5"."Comment" = "Press, move down, move half up, move right, move down, release.\n(Drawing a lowercase 'h'.)";
        "Data_3_5"."Enabled" = true;
        "Data_3_5"."Name" = "Home";
        "Data_3_5"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_5Actions"."ActionsCount" = 1;
        "Data_3_5Actions0"."DestinationWindow" = 2;
        "Data_3_5Actions0"."Input" = "Alt+Home\n";
        "Data_3_5Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_5Conditions"."Comment" = "";
        "Data_3_5Conditions"."ConditionsCount" = 0;
        "Data_3_5Triggers"."Comment" = "Gesture_triggers";
        "Data_3_5Triggers"."TriggersCount" = 2;
        "Data_3_5Triggers0"."GesturePointData" = "0,0.0461748,0.5,0,0,0.0461748,0.0461748,0.5,0,0.125,0.0923495,0.0461748,0.5,0,0.25,0.138524,0.0461748,0.5,0,0.375,0.184699,0.0461748,0.5,0,0.5,0.230874,0.0461748,0.5,0,0.625,0.277049,0.0461748,0.5,0,0.75,0.323223,0.0461748,0.5,0,0.875,0.369398,0.065301,-0.25,0,1,0.434699,0.065301,-0.25,0.125,0.875,0.5,0.065301,-0.25,0.25,0.75,0.565301,0.065301,-0.25,0.375,0.625,0.630602,0.0461748,0,0.5,0.5,0.676777,0.0461748,0,0.625,0.5,0.722951,0.0461748,0,0.75,0.5,0.769126,0.0461748,0,0.875,0.5,0.815301,0.0461748,0.5,1,0.5,0.861476,0.0461748,0.5,1,0.625,0.90765,0.0461748,0.5,1,0.75,0.953825,0.0461748,0.5,1,0.875,1,0,0,1,1";
        "Data_3_5Triggers0"."Type" = "GESTURE";
        "Data_3_5Triggers1"."GesturePointData" = "0,0.0416667,0.5,0,0,0.0416667,0.0416667,0.5,0,0.125,0.0833333,0.0416667,0.5,0,0.25,0.125,0.0416667,0.5,0,0.375,0.166667,0.0416667,0.5,0,0.5,0.208333,0.0416667,0.5,0,0.625,0.25,0.0416667,0.5,0,0.75,0.291667,0.0416667,0.5,0,0.875,0.333333,0.0416667,-0.5,0,1,0.375,0.0416667,-0.5,0,0.875,0.416667,0.0416667,-0.5,0,0.75,0.458333,0.0416667,-0.5,0,0.625,0.5,0.0416667,0,0,0.5,0.541667,0.0416667,0,0.125,0.5,0.583333,0.0416667,0,0.25,0.5,0.625,0.0416667,0,0.375,0.5,0.666667,0.0416667,0,0.5,0.5,0.708333,0.0416667,0,0.625,0.5,0.75,0.0416667,0,0.75,0.5,0.791667,0.0416667,0,0.875,0.5,0.833333,0.0416667,0.5,1,0.5,0.875,0.0416667,0.5,1,0.625,0.916667,0.0416667,0.5,1,0.75,0.958333,0.0416667,0.5,1,0.875,1,0,0,1,1";
        "Data_3_5Triggers1"."Type" = "GESTURE";
        "Data_3_6"."Comment" = "Press, move right, move down, move right, release.\nMozilla-style: Press, move down, move right, release.";
        "Data_3_6"."Enabled" = true;
        "Data_3_6"."Name" = "Close Tab";
        "Data_3_6"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_6Actions"."ActionsCount" = 1;
        "Data_3_6Actions0"."DestinationWindow" = 2;
        "Data_3_6Actions0"."Input" = "Ctrl+W\n";
        "Data_3_6Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_6Conditions"."Comment" = "";
        "Data_3_6Conditions"."ConditionsCount" = 0;
        "Data_3_6Triggers"."Comment" = "Gesture_triggers";
        "Data_3_6Triggers"."TriggersCount" = 2;
        "Data_3_6Triggers0"."GesturePointData" = "0,0.0625,0,0,0,0.0625,0.0625,0,0.125,0,0.125,0.0625,0,0.25,0,0.1875,0.0625,0,0.375,0,0.25,0.0625,0.5,0.5,0,0.3125,0.0625,0.5,0.5,0.125,0.375,0.0625,0.5,0.5,0.25,0.4375,0.0625,0.5,0.5,0.375,0.5,0.0625,0.5,0.5,0.5,0.5625,0.0625,0.5,0.5,0.625,0.625,0.0625,0.5,0.5,0.75,0.6875,0.0625,0.5,0.5,0.875,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
        "Data_3_6Triggers0"."Type" = "GESTURE";
        "Data_3_6Triggers1"."GesturePointData" = "0,0.0625,0.5,0,0,0.0625,0.0625,0.5,0,0.125,0.125,0.0625,0.5,0,0.25,0.1875,0.0625,0.5,0,0.375,0.25,0.0625,0.5,0,0.5,0.3125,0.0625,0.5,0,0.625,0.375,0.0625,0.5,0,0.75,0.4375,0.0625,0.5,0,0.875,0.5,0.0625,0,0,1,0.5625,0.0625,0,0.125,1,0.625,0.0625,0,0.25,1,0.6875,0.0625,0,0.375,1,0.75,0.0625,0,0.5,1,0.8125,0.0625,0,0.625,1,0.875,0.0625,0,0.75,1,0.9375,0.0625,0,0.875,1,1,0,0,1,1";
        "Data_3_6Triggers1"."Type" = "GESTURE";
        "Data_3_7"."Comment" = "Press, move up, release.\nConflicts with Opera-style 'Up #2', which is disabled by default.";
        "Data_3_7"."Enabled" = true;
        "Data_3_7"."Name" = "New Tab";
        "Data_3_7"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_7Actions"."ActionsCount" = 1;
        "Data_3_7Actions0"."DestinationWindow" = 2;
        "Data_3_7Actions0"."Input" = "Ctrl+Shift+N";
        "Data_3_7Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_7Conditions"."Comment" = "";
        "Data_3_7Conditions"."ConditionsCount" = 0;
        "Data_3_7Triggers"."Comment" = "Gesture_triggers";
        "Data_3_7Triggers"."TriggersCount" = 1;
        "Data_3_7Triggers0"."GesturePointData" = "0,0.125,-0.5,0.5,1,0.125,0.125,-0.5,0.5,0.875,0.25,0.125,-0.5,0.5,0.75,0.375,0.125,-0.5,0.5,0.625,0.5,0.125,-0.5,0.5,0.5,0.625,0.125,-0.5,0.5,0.375,0.75,0.125,-0.5,0.5,0.25,0.875,0.125,-0.5,0.5,0.125,1,0,0,0.5,0";
        "Data_3_7Triggers0"."Type" = "GESTURE";
        "Data_3_8"."Comment" = "Press, move down, release.";
        "Data_3_8"."Enabled" = true;
        "Data_3_8"."Name" = "New Window";
        "Data_3_8"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_8Actions"."ActionsCount" = 1;
        "Data_3_8Actions0"."DestinationWindow" = 2;
        "Data_3_8Actions0"."Input" = "Ctrl+N\n";
        "Data_3_8Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_8Conditions"."Comment" = "";
        "Data_3_8Conditions"."ConditionsCount" = 0;
        "Data_3_8Triggers"."Comment" = "Gesture_triggers";
        "Data_3_8Triggers"."TriggersCount" = 1;
        "Data_3_8Triggers0"."GesturePointData" = "0,0.125,0.5,0.5,0,0.125,0.125,0.5,0.5,0.125,0.25,0.125,0.5,0.5,0.25,0.375,0.125,0.5,0.5,0.375,0.5,0.125,0.5,0.5,0.5,0.625,0.125,0.5,0.5,0.625,0.75,0.125,0.5,0.5,0.75,0.875,0.125,0.5,0.5,0.875,1,0,0,0.5,1";
        "Data_3_8Triggers0"."Type" = "GESTURE";
        "Data_3_9"."Comment" = "Press, move up, move down, release.";
        "Data_3_9"."Enabled" = true;
        "Data_3_9"."Name" = "Reload";
        "Data_3_9"."Type" = "SIMPLE_ACTION_DATA";
        "Data_3_9Actions"."ActionsCount" = 1;
        "Data_3_9Actions0"."DestinationWindow" = 2;
        "Data_3_9Actions0"."Input" = "F5";
        "Data_3_9Actions0"."Type" = "KEYBOARD_INPUT";
        "Data_3_9Conditions"."Comment" = "";
        "Data_3_9Conditions"."ConditionsCount" = 0;
        "Data_3_9Triggers"."Comment" = "Gesture_triggers";
        "Data_3_9Triggers"."TriggersCount" = 1;
        "Data_3_9Triggers0"."GesturePointData" = "0,0.0625,-0.5,0.5,1,0.0625,0.0625,-0.5,0.5,0.875,0.125,0.0625,-0.5,0.5,0.75,0.1875,0.0625,-0.5,0.5,0.625,0.25,0.0625,-0.5,0.5,0.5,0.3125,0.0625,-0.5,0.5,0.375,0.375,0.0625,-0.5,0.5,0.25,0.4375,0.0625,-0.5,0.5,0.125,0.5,0.0625,0.5,0.5,0,0.5625,0.0625,0.5,0.5,0.125,0.625,0.0625,0.5,0.5,0.25,0.6875,0.0625,0.5,0.5,0.375,0.75,0.0625,0.5,0.5,0.5,0.8125,0.0625,0.5,0.5,0.625,0.875,0.0625,0.5,0.5,0.75,0.9375,0.0625,0.5,0.5,0.875,1,0,0,0.5,1";
        "Data_3_9Triggers0"."Type" = "GESTURE";
        "DirSelect Dialog"."DirSelectDialog Size[$d]" = "";
        "General"."ColorSchemeHash[$d]" = "";
        "General"."ColorScheme[$d]" = "";

        "Gestures"={"Disabled" = true; "MouseButton" = 2; "Timeout" = 300;};

        "GesturesExclude"={"Comment" = ""; "WindowsCount" = 0;};
        "Icons"."Theme[$d]" = "";
        "KDE"={"LookAndFeelPackage[$d]" = ""; "widgetStyle[$d]" = "";};

        "KFileDialog Settings"={
          "Allow Expansion[$d]" = "";
          "Automatically select filename extension[$d]" = "";
          "Breadcrumb Navigation[$d]" = "";
          "Decoration position[$d]" = "";
          "LocationCombo Completionmode[$d]" = "";
          "PathCombo Completionmode[$d]" = "";
          "Show Bookmarks[$d]" = "";
          "Show Full Path[$d]" = "";
          "Show Inline Previews[$d]" = "";
          "Show Preview[$d]" = "";
          "Show Speedbar[$d]" = "";
          "Show hidden files[$d]" = "";
          "Sort by[$d]" = "";
          "Sort directories first[$d]" = "";
          "Sort hidden files last[$d]" = "";
          "Sort reversed[$d]" = "";
          "Speedbar Width[$d]" = "";
          "View Style[$d]" = "";
          };

        "Main"={"AlreadyImported" = "defaults,kde32b1,konqueror_gestures_kde321"; "Disabled" = false;};
        "Voice"."Shortcut" = "";

        "WM"={"activeBackground[$d]" = "";
              "activeBlend[$d]" = "";
              "activeForeground[$d]" = "";
              "inactiveBackground[$d]" = "";
              "inactiveBlend[$d]" = "";
              "inactiveForeground[$d]" = "";
              };

        };
      "kiorc"={"Confirmations"={"ConfirmDelete" = true; "ConfirmEmptyTrash" = true; "ConfirmTrash" = false;}; "Executable scripts"."behaviourOnLaunch" = "alwaysAsk";};

      "kservicemenurc"."Show"={
        "compressfileitemaction" = true;
        "extractfileitemaction" = true;
        "forgetfileitemaction" = true;
        "installFont" = true;
        "kactivitymanagerd_fileitem_linking_plugin" = true;
        "kdeconnectfileitemaction" = true;
        "kio-admin" = true;
        "makefileactions" = true;
        "mountisoaction" = true;
        "runInKonsole" = true;
        "slideshowfileitemaction" = true;
        "tagsfileitemaction" = true;
        "wallpaperfileitemaction" = true;
        };

      "kwalletrc"."Wallet"."First Use" = false;
      "kwinrc"={
        "Desktops"={"Id_1" = "a02029fa-0893-4705-a81a-48db139bb0a0"; "Number" = 1;"Rows" = 1;};
        "Tiling"."padding" = 4;
        "Tiling/55c3c6d7-6f55-5266-943e-cc75d862efbd"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
        "Tiling/6d2a3b2b-8abe-5a36-b7a1-86a7ef4473c7"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
        "Tiling/8939a3d9-2a8b-528b-a13d-6ca4773f18b0"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
        "Tiling/bd1c774f-7bca-5e79-b5b2-a7f2d395ce9c"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
        "Xwayland"."Scale" = 1.25;
        };
      "kxkbrc"."Layout"={"DisplayNames" = ","; "LayoutList" = "us,eg"; "Options" = "grp:alt_shift_toggle"; "ResetOldOptions" = true; "Use" = true; "VariantList" = ","; };

      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";

      "plasmanotifyrc"={
        "Applications/beeper"."Seen" = true;
        "Applications/floorp"."Seen" = true;
        "Applications/kotatogramdesktop"."Seen" = true;
        "Applications/org.qbittorrent.qBittorrent"."Seen" = true;
        };
    };
  };

 # services={
  # gvfs.enable = true;
  # devmon.enable = true;
  # udisks2.enable = true;
  # xserver.displayManager = {
  #   sddm = {
  #     settings = { Autologin = {
  #                  Session = "plasmawayland";
  #                  User = userSettings.username;
  # }; };
  #     settings.Wayland.SessionDir = "${pkgs.plasma5Packages.plasma-workspace}/share/wayland-sessions";
  #     #autoLogin.minimumUid = 1000 ;
  #     };
  #     #job.execCmd = lib.mkForce "exec /run/current-system/sw/bin/sddm";
  #     };
# };
}
