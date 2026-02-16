{ config, pkgs, ... }:
{
  programs.nixcord = {
    enable = true;
    
    vesktop.enable = true;

	#    config = {
	#      notifyAboutUpdates = true;
	#      AutoDNDWhilePlaying = {
	#        enable = true;
	# excludeInvisible = true;
	#      };
	#
	#      ClearURLs.enable = true;
	#      CopyUserURLs.enable = true;
	#    };
  };
}
