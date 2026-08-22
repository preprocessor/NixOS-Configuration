{
  exo.mods.gaming =
    { pkgs, ... }:
    {
      hj.packages = [
        (pkgs.rpcs3.overrideAttrs (
          finalAttrs: prevAttrs: {
            doCheck = false;
            version = "0.0.42-unstable-2026-08-15";
            src = pkgs.fetchFromGitHub {
              owner = "RPCS3";
              repo = "rpcs3";
              rev = "fc93d932c8560f763f5223c0a4165cc53bceeb3f";
              hash = "sha256-3sGcpYfaxZNa6/CIRxylSf/EL+ievwIeQzEKYDOUNy8=";
              postCheckout = ''
                cd $out/3rdparty
                git submodule update --init \
                fusion/fusion asmjit/asmjit yaml-cpp/yaml-cpp SoundTouch/soundtouch stblib/stb \
                feralinteractive/feralinteractive wolfssl/wolfssl
              '';
            };
          }
        ))
      ];
    };
}
