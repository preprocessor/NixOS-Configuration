{
  modules.host.ramiel = { config, lib, ... }: {
    my.services.udiskie = {
      enable = true;
      settings.program_options.file_manager = "${lib.getExe config.my.kitty.package} -e ${lib.getExe config.my.yazi.package}";
    };
  };
}
