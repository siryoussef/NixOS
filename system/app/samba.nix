{...}:{
services={
	samba-wsdd.enable = true;
	samba = {
		enable = true;
		nmbd.enable = true;
		winbindd.enable = false;
		openFirewall= true;
		nsswins = false;
		settings =
		{ Shared = { path = "/Shared"; "read only" = false; browseable = "yes"; "guest ok" = "yes"; comment = "Wanky shared volume"; };
		Labvol = { path = "/Volume"; "read only" = false; browseable = "yes"; "guest ok" = "yes"; comment = "Wanky Main Volume"; };
		};
	};
};
}
