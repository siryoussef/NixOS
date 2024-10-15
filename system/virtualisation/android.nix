{pkgs, settings, config,...}:
{virtualisation={
	waydroid.enable = true;
    anbox = {enable = false; image = pkgs.anbox.image;};
};
#     environment={
#     systemPackages = let pkglists=settings.pkglists; in pkglists.virtualisation.system;
#     persistence= let storage = import settings.paths.storage{inherit settings config;}; in storage.persistent.waydroid.system;
# };
}
