{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "spoti-flac";
  version = "7.1.6";

  src = fetchFromGitHub {
    owner = "spotbye";
    repo = "SpotiFLAC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iQBJS2IsOzamC1plkd9BGbSajY9UpomaXMJRJgQ36t4=";
  };

  vendorHash = "sha256-CEnh8YNxCY4Z33DJW9fPGLg+AHGBoyf1ECzdgi7c5eA=";

  ldflags = [ "-s" ];

  meta = {
    description = "Get Spotify tracks in true FLAC from Tidal, Qobuz & Amazon Music — no account required";
    homepage = "https://github.com/spotbye/SpotiFLAC";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "spoti-flac";
  };
})
