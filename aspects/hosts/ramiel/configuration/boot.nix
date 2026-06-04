{
  w.ramiel =
    { pkgs, ... }:
    {
      environment.etc.issue.source = pkgs.writeText "etc/issue" ''
                              :::!~!!!!!:.
                          .xUHWH!! !!?M88WHX:.
                        .X*#M@$!!  !X!M$$$$$$WWx:.
                       :!!!!!!?H! :!$!$$$$$$$$$$8X:
                      !!~  ~:~!! :~!$!#$$$$$$$$$$8X:
                     :!~::!H!<   ~.U$X!?R$$$$$$$$MM!
                     ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!
                       !:~~~ .:!M"T#$$$$WX??#MRRMMM!
                       ~?WuxiW*`   `"#$$$$8!!!!??!!!
                     :X- M$$$$    .  `"T#$T~!8$WUXU~
                    :%`  ~#$$$m:        ~!~ ?$$$$$$
                  :!`.-   ~T$$$$8xx.  .xWW- ~""##*"
        .....   -~~:<` !    ~?T#$$@@W@*?$$  .   /`
        W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :
        #"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`
        :::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~
        .~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `
        Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!
        $R@i.~~ !     :   ~$$$$$B$$en:``
        ?MXT@Wx.~    :     ~"##*$$$$M~
      '';

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        initrd.systemd.enable = true;
        consoleLogLevel = 3;
        loader.timeout = 1;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
      };
    };
}
