cask "stash-video" do
  version "1.7.2,20261014"
  sha256 "02ba1acc9adc4fa78ab9a9ad9ee9467dd07ec7cf3fb347219db7cacbec24ed55"

  url "https://github.com/hov172/StashVideos/releases/download/v#{version.csv.first}/StashVideo-#{version.csv.first}-#{version.csv.second}.pkg"
  name "Stash Video"
  desc "Native front end for yt-dlp"
  homepage "https://github.com/hov172/StashVideos"

  livecheck do
    url :url
    regex(/^StashVideo[._-]v?(\d+(?:\.\d+)+)[._-](\d{8})\.pkg$/i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  depends_on macos: ">= :sonoma"

  pkg "StashVideo-#{version.csv.first}-#{version.csv.second}.pkg"

  # The installer links yt-dlp, ffmpeg and ffprobe into /usr/local/bin only when nothing is
  # there already; remove just the links that point into this app, never a user's own tools.
  uninstall script:  {
                       executable: "/bin/sh",
                       args:       ["-c", <<~SH.strip],
                         for t in yt-dlp ffmpeg ffprobe; do
                           l="/usr/local/bin/$t"
                           [ -L "$l" ] || continue
                           case "$(readlink "$l")" in
                             */Stash\ Video.app/Contents/Resources/bin/*) rm -f "$l" ;;
                           esac
                         done
                         exit 0
                       SH
                       sudo:       true,
                     },
            pkgutil: "com.ayala.solutions.yt-dlp-gui-Macos.pkg",
            delete:  "/Applications/Stash Video.app"

  zap trash: [
    "~/Library/Application Support/com.ayala.solutions.yt-dlp-gui-Macos",
    "~/Library/Caches/com.ayala.solutions.yt-dlp-gui-Macos",
    "~/Library/Preferences/com.ayala.solutions.yt-dlp-gui-Macos.plist",
  ]
end
