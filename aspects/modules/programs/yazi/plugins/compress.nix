{
  modules.core = {
    my.yazi.keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "C" ];
          run = "plugin compress";
          desc = "Compress";
        }
      ];
    };
  };
}
