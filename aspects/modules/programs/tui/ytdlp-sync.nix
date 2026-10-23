{
  exo.host.ramiel = { pkgs, ... }: {
    hj.packages =
      let
        yt-dlp-sync = pkgs.writers.writePython3Bin "yt-dlp-sync" { flakeIgnore = [ "E501" ]; } /* python */ ''
          import argparse
          import logging
          import logging.handlers
          import subprocess
          import sys
          from pathlib import Path


          def parse_args() -> argparse.Namespace:
              parser = argparse.ArgumentParser(
                  description="Sync a YouTube playlist to a local directory as FLAC audio."
              )
              parser.add_argument("playlist_url", help="YouTube playlist URL")
              parser.add_argument("output_dir", help="Download location")
              return parser.parse_args()


          def main() -> int:
              args = parse_args()

              output_dir = Path(args.output_dir).expanduser()
              output_dir.mkdir(parents=True, exist_ok=True)

              log_path = str(output_dir / "log.txt")
              archive_path = str(output_dir / "archive.txt")

              logging.basicConfig(
                  level=logging.INFO,
                  format="%(asctime)s %(levelname)s %(message)s",
                  handlers=[
                      logging.handlers.RotatingFileHandler(
                          log_path, maxBytes=1_000_000, backupCount=5
                      ),
                      logging.StreamHandler(),
                  ],
              )

              logging.info("=== sync started ===")

              cmd: list[str] = [
                  "yt-dlp",
                  "--extract-audio",
                  "--audio-format", "m4a",
                  "--embed-thumbnail",
                  "--convert-thumbnails", "jpg",
                  "--add-metadata",
                  "--yes-playlist",
                  "--download-archive", archive_path,
                  "-N", "4",
                  "--quiet",
                  "--no-warnings",
                  "--no-write-thumbnail",
                  "--cookies", "/home/wyspr/Documents/www.youtube.com_cookies.txt",
                  # only prints for newly downloaded files (after move to final location)
                  "--print", "after_move:Downloaded: %(title)s",
                  "-o", str(output_dir / "%(title)s.%(ext)s"),
                  args.playlist_url,
              ]

              try:
                  result = subprocess.run(cmd, capture_output=True, text=True)
              except FileNotFoundError:
                  logging.error("yt-dlp not found in PATH")
                  logging.info("=== sync finished (exit code 127) ===")
                  return 127

              for line in result.stdout.strip().splitlines():
                  logging.info(line)

              for line in result.stderr.strip().splitlines():
                  logging.error(line)

              if result.returncode != 0:
                  logging.error(f"yt-dlp exited with code {result.returncode}")

              logging.info(f"=== sync finished (exit code {result.returncode}) ===")
              return result.returncode


          if __name__ == "__main__":
              sys.exit(main())
        '';
      in
      [
        yt-dlp-sync
        pkgs.yt-dlp
      ];

  };
}
