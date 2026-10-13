# Third-party software in Stash Video

Stash Video ships four independent programs in
`Stash Video.app/Contents/Resources/bin`. It does not link against them: it runs
each as a separate process and talks to it over a command line and pipes. They
are unmodified upstream builds, and their own licenses govern them — not
Stash Video's [LICENSE](LICENSE).

The full license texts are in [`licenses/`](licenses/), and the same folder is
installed inside the app bundle at `Contents/Resources/licenses`.

| Program | Source | License |
|---|---|---|
| [FFmpeg](https://ffmpeg.org) (`ffmpeg`, `ffprobe`) | [ffmpeg.martin-riedl.de](https://ffmpeg.martin-riedl.de) static macOS builds | **GPL v3 or later** — [GPL-3.0.txt](licenses/GPL-3.0.txt) |
| [yt-dlp](https://github.com/yt-dlp/yt-dlp) | official `yt-dlp_macos` release | The Unlicense for yt-dlp's own source, plus GPLv3+ components in the PyInstaller executable — [yt-dlp-Unlicense.txt](licenses/yt-dlp-Unlicense.txt) and [yt-dlp-THIRD_PARTY_LICENSES.txt](licenses/yt-dlp-THIRD_PARTY_LICENSES.txt) |
| [Deno](https://deno.com) | official release archives | MIT — [deno-MIT.txt](licenses/deno-MIT.txt) |

**Exact versions are not listed here on purpose.** They changed once already and this file did
not, which is how a licence notice starts describing software nobody ships. `build-installer.sh`
writes `licenses/bundled-versions.txt` into every package, read from the binaries themselves at
build time — that file, inside the copy you have, is authoritative.

All four are universal binaries (arm64 + x86_64).

## FFmpeg — GPL v3

This is the obligation that actually constrains distribution, so it is worth
stating precisely.

The bundled build comes from [ffmpeg.martin-riedl.de](https://ffmpeg.martin-riedl.de), which
publishes static macOS builds for both architectures from the same build run, and is
configured with `--enable-gpl --enable-version3` (it includes x264, x265 and
other GPL-licensed components). It also statically incorporates the external libraries shown by its configure output. That combination makes the binary **GPL v3 or
later**. It is *not* an `--enable-nonfree` build, which could not be
redistributed at all.

(FFmpeg's own libraries — `libavcodec`, `libavformat` and the rest — are LGPL,
and `--enable-version3` makes that LGPL v3: [LGPL-3.0.txt](licenses/LGPL-3.0.txt).
The GPL-licensed components compiled in raise the resulting *binary* to GPL v3,
which is the term that governs what ships here.)

What that means here:

- **FFmpeg is aggregated with Stash Video, not combined into it.** It is a
  separate executable invoked as a subprocess. Stash Video's own code stays
  under its own terms; the GPL applies to FFmpeg and to anything derived from
  it.
- **The license text must travel with the binary.** It does:
  `licenses/GPL-3.0.txt` in this repository, and
  `Contents/Resources/licenses/GPL-3.0.txt` inside every installed copy of the
  app.
- **Corresponding source must be available.** See below.

### Written offer for FFmpeg source

The FFmpeg binaries distributed with Stash Video are unmodified static builds published by
ffmpeg.martin-riedl.de. The corresponding source must include FFmpeg, the sources and build
information for GPL-covered external libraries incorporated into the binary, and any patches
used by the publisher. The base FFmpeg tarball alone may not be sufficient for this static build.

- **Inside the app itself**, at `Contents/Resources/licenses/ffmpeg-<version>.tar.xz`. The
  source travels with the binary it corresponds to, so mirroring or re-hosting the installer
  carries it automatically — there is nothing a redistributor can forget to copy. The build
  fails if it is absent.
- The package also carries [`ffmpeg-corresponding-source-manifest.txt`](licenses/ffmpeg-corresponding-source-manifest.txt)
  and the publisher's [`ffmpeg-martin-riedl-build-script.tar.gz`](licenses/ffmpeg-martin-riedl-build-script.tar.gz).
  The manifest records every enabled external library and the audit limitation: the publisher's
  prebuilt archive does not contain every dependency source archive or commit. Those sources
  must be obtained from the listed upstream projects or the publisher's written source offer
  before redistributing a release as a complete corresponding-source bundle.
- **Attached to the GitHub release** as well, for anyone who wants the source without
  installing anything. `Scripts/fetch-ffmpeg-source.sh` fetches the tarball matching the
  built binary.
- Upstream: <https://ffmpeg.org/releases/> and <https://git.ffmpeg.org/ffmpeg.git>
  (tag `n<version>`)
- The exact configure line of the shipped binary is recorded in
  [`licenses/ffmpeg-build-config.txt`](licenses/ffmpeg-build-config.txt), regenerated from the
  binary on every build, and shipped inside the app.

For a period of three years from the date you received this software, Ayala
Solutions will provide, on request and for no more than the cost of physically
performing the distribution, a complete machine-readable copy of the
corresponding source code for the FFmpeg binaries distributed with Stash Video.
Contact: ayala.solutions@gmail.com

> **If you redistribute Stash Video yourself**, this obligation becomes yours as well —
> Do not remove the source files or license notices from the package. Verify that the complete
> corresponding source for the exact FFmpeg build is included before redistributing it.

## yt-dlp — mixed licensing

yt-dlp's own source is released under the Unlicense, but the official PyInstaller-bundled
`yt-dlp_macos` executable includes GPLv3+ code and is therefore a combined GPLv3+ work. The
package carries the complete upstream `THIRD_PARTY_LICENSES.txt` as
`licenses/yt-dlp-THIRD_PARTY_LICENSES.txt`; it must remain with the executable. See the
[upstream licensing explanation](https://github.com/yt-dlp/yt-dlp/blob/2026.08.19/README.md#licensing).

The executable is verified against the pinned publisher SHA-256 digest at fetch time (see
`Scripts/helper-binaries.lock.json`).

Stash Video re-signs it with `com.apple.security.cs.disable-library-validation`
so macOS's hardened runtime will let it load the Python framework it unpacks at
runtime. The program itself is unmodified.

## Deno — MIT

MIT licensed; the notice in `licenses/deno-MIT.txt` must accompany
redistribution. Stash Video re-signs it with JIT entitlements, which V8
requires under the hardened runtime. The program itself is unmodified.

## Re-signing and modification

All four binaries are re-signed with a Developer ID certificate so they satisfy
macOS notarization. Re-signing changes a binary's code signature, not its code.
None of these programs is patched or recompiled. Re-signing changes the signature and does not
remove the obligation to provide the license notices and corresponding source required by the
component licenses.
