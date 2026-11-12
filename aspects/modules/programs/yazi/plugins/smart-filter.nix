{
  modules.core = {
    my.yazi.keymap = {
      mgr.prepend_keymap = [
        {
          on = "f";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
      ];
    };
  };
}
