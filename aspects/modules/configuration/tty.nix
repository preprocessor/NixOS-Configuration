{
  w.default =
    { constants, ... }:
    {
      services.getty = {
        extraArgs = [
          "--skip-login"
          "--noreset"
          "--noclear"
          "-"
          "\${TERM}"
        ];

        loginOptions = "-- ${constants.username}";
      };
    };
}
