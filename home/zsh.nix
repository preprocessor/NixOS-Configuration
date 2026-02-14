{ config, pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;

      autocd = true;

      enableCompletion = true;

      history = {
        append = true;
        expireDuplicatesFirst = true;

        # If a new command line being added to the history list duplicates an older one,
        # the older command is removed from the list (even if it is not the previous event).
        ignoreAllDups = true;

        # Do not enter comm and lines into the history list if the first character is a space.
        ignoreSpace = true;

        # Do not display a line previously found in the history file.
        findNoDups = true;

        # Do not write duplicate entries into the history file.
        saveNoDups = true;

        # Share command history between zsh sessions.
        share = true;
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };

    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
