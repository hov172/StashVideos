# Changelog

All notable changes to Stash Video. Versions follow [semantic versioning](https://semver.org):
the minor number moves for new capability, the patch number for fixes.

## [Unreleased]

- **Localization.** The interface follows the macOS system language in English, German, Greek,
  Spanish, French, Italian, Japanese, Korean, Polish, Brazilian Portuguese, Russian, Ukrainian,
  Simplified and Traditional Chinese. A globe menu in the toolbar sets an app-only language
  override, applied on the next launch. Translations were machine-generated and reviewed for
  format safety, not by native speakers; corrections are welcome as issues.

- **Appearance.** `Settings ▸ General ▸ Appearance` chooses System, Light or Dark; the default follows
  the Mac.
- **Release check.** The app checks the public release feed once a day at launch and shows a banner
  with a link to the release page when a newer Stash Video exists. `Settings ▸ Updates ▸ Check Now`
  checks on demand.
- **Homebrew.** `brew tap hov172/stashvideos https://github.com/hov172/StashVideos`, then
  `brew install --cask stash-video` installs the same signed package as the release page.

## [1.5.2] — 2026-09-17

- Ship the complete yt-dlp third-party notices and a corrected notice for each bundled helper.
- Include the FFmpeg corresponding-source manifest and the upstream build script alongside the
  FFmpeg source archive already embedded in the installer.
- State the content-owner permission requirement more prominently in user documentation.
- Internal: share one thread-safe output collector between analysis and embed-page resolution,
  one settings-pane persistence modifier, and one "URL changed during analyze" guard. Fold the
  last duplicate subprocess test double into `ScriptedRunner`. Tests use `#require` instead of
  force unwraps. No behavior change.

## [1.5.1] — 2026-09-09

- Refine About window branding with a larger Ayala Solutions mark, balanced spacing, and a
  subtle “Developed by” label. Native text adapts to light and dark appearance.
- Group vendor information for accessibility and separate it clearly from app details.
- Add the content-owner permission disclaimer to user documentation and release notes.
- Describe supported video collections more generally in the README and release notes.

## [1.5.0] — 2026-09-09

- Add Apple Developer’s All Videos catalog as a searchable collection. Choose videos by title
  or session ID and download through the shared queue; catalog entries start unchecked.
- Keep audio streams selectable when the source omits a codec name. Identify unknown audio
  through a bounded, cancellable probe with HTTPS verification; show AAC · M4A · HLS when detected.
- Automatically number duplicate output filenames while preserving existing files. Handle
  concurrent saves and partial-save retries, and use actual saved names in history and Finder.
- Add collection search and selection of search results to the playlist view.

## [1.4.4] — 2026-09-07

- Separate subprocess stdout/stderr so warnings cannot invalidate analysis metadata.
- Keep playlist batches waiting across pause/resume; support multiple completion observers.
- Retain files after publication failures and retry saving without another download. Track
  committed outputs, detect dangling-link collisions, and copy across volumes in cancellable chunks.
- Clean removed/resumed jobs by workspace ownership, with background cleanup awaited on quit.
- Give different feed videos independent destination reservations while serializing duplicates.
- Bound feed response bodies during receipt and cancel oversized transfers immediately.
- Clean browser profiles on natural exit and failed launch; close the app-owned browser on quit.
- Label playlist and queue controls for accessibility; render queue rows lazily.
- Extract download admission/session ownership into DownloadCoordinator and migrate all targets
  to Swift 6 language mode with complete concurrency checking.

## [1.4.3] — 2026-09-07

### Fixed

- Preserve existing destination files. Downloads use private working directories and publish
  without overwriting; cancellation removes only files owned by that job.
- Share concurrency limits across direct, stream, playlist, and feed downloads. Active and
  paused jobs reserve destinations, and changing the limit starts eligible queued work.
- Enforce lossless remuxing and explicit H.264/AAC or VP9/Opus conversion, including inputs
  already using the requested container.
- Capture each job's metadata and settings so history, timestamps, notifications, and resumed
  downloads cannot inherit another video's state.
- Apply dependency overrides, Deno paths, proxy settings, and successful impersonation
  consistently. Discard stale analysis and feed results after edits or cancellation.
- Stop process groups reliably, escalate ignored interrupts, and wait for cleanup on quit.
- Stage yt-dlp updates independently and replace the verified executable atomically.

### Build and verification

- Pin all seven helper artifacts and SHA-256 digests; verify every download before replacing
  installed tools. Bundle yt-dlp 2026.08.19, FFmpeg/ffprobe 9.0.1, and Deno 2.9.6.
- Add real-tool offline media integration coverage and helper failure-path tests. Pin the CI
  checkout action and restrict workflow repository permissions to read-only.
- Update the user guide, architecture summary, release procedure, and review record.

Existing filenames now produce a collision error; choose another filename to keep another copy.
Paused downloads resume within the current app session. Quitting discards their private workspace.

## [1.4.2] — 2026-08-22

### Fixed

- **The installer could put the app somewhere other than `/Applications`.** macOS *bundle
  relocation*: when the app is absent from its install location but a bundle with the same
  identifier exists elsewhere on disk, `installd` updates that copy instead — silently, while
  still writing a receipt that claims `location: Applications`.

  Observed on a real install: the package landed in an Xcode build directory. No app appeared
  in `/Applications`, `postinstall` found no bundled tools so created no `/usr/local/bin` links,
  quarantine was never cleared, and the receipt described an install that had not happened. It
  also left root-owned files inside the build product, which then blocked rebuilds.

  `pkgbuild` marks bundles relocatable by default, so **every release from 1.2.0 through 1.4.1
  carries this**. It stayed hidden because it only triggers when `/Applications/Stash Video.app`
  is missing *and* another copy exists — which is exactly the state after running the
  uninstaller, and the normal state for anyone with a checkout of this project.

  The component plist now sets `BundleIsRelocatable` to false, the build asserts the flag took,
  and CI fails if the app bundle ever appears in the package's relocate block. The failure is
  invisible from outside — the package installs successfully and reports success — so it needs
  a check rather than a reader.

## [1.4.1] — 2026-08-22

### Fixed

- **The uninstaller left its own receipt behind.** Running the shipped uninstaller removed
  everything it should — the app, the `/usr/local/bin` links, the installer receipt — and then
  left `com.ayala.solutions.yt-dlp-gui-Macos.uninstaller` still registered with `pkgutil`.

  A package cannot forget itself from inside its own `postinstall`: `installd` writes the
  receipt *after* the script exits, so the inline `pkgutil --forget` ran against a receipt that
  did not exist yet, succeeded, and achieved nothing. A detached job now waits for `installd`
  to finish and clears it.

  Only running the real package caught this. The fake-root tests and the CI check both passed
  on the broken version, because neither involves `installd` at all.

## [1.4.0] — 2026-08-22

### Added

- **An uninstaller package.** Removing Stash Video previously meant either dragging the app to
  the Trash — which leaves the `/usr/local/bin` links and the package receipt behind — or
  finding `Scripts/uninstall.sh` in a source checkout, which nobody who installed from a `.pkg`
  has.

  `StashVideo-Uninstaller-<version>-<date>.pkg` is a payload-free package: it installs nothing,
  and exists only to run its removal script. It ships **inside the app** at
  `Contents/Resources/StashVideo-Uninstaller.pkg` and is attached to the release, so it is
  reachable whether or not you still have the download. Signed and notarized like the
  installer, so it does not trip Gatekeeper.

  It removes the app, the `/usr/local/bin` links the installer created, and both package
  receipts. It applies the same ownership test as the installer, so a Homebrew `ffmpeg` at that
  path is left standing. **Settings, cached data and downloaded videos are kept** — a
  double-clickable package has no confirmation beyond the Install button and no undo, which is
  the wrong place to destroy data someone may still want; the final screen names what to remove
  for a clean slate.

### Fixed

- `pkgutil --forget` in the uninstall path now passes `--volume`. Without it pkgutil always
  edits the boot volume's receipt database, so an uninstall aimed at another disk would forget
  the receipt of the copy installed on *this* Mac instead.

## [1.3.1] — 2026-08-21

### Changed

- **The FFmpeg source now ships inside the package**, at
  `Contents/Resources/licenses/ffmpeg-<version>.tar.xz`. 1.3.0 attached it to the GitHub
  release only, which met the GPL's corresponding-source requirement but left it separable:
  anyone re-hosting the `.pkg` on their own site had to remember to carry the tarball too, and
  a mirror that forgot would be distributing a GPL binary with no source in reach.

  Embedding it removes that failure mode — distributing the package unmodified now distributes
  the source with it, and the written offer in THIRD-PARTY-LICENSES.md drops to a backstop.
  `build-installer.sh` fetches the tarball matching the built binary and **fails** if it cannot,
  and CI checks the payload contains it. It is still attached to the release as well, for
  anyone who wants the source without installing anything.

  Cost: about 11 MB on top of the package.

## [1.3.0] — 2026-08-21

### Fixed

- **The app and its tools are now universal binaries.** Previous packages were Apple
  Silicon–only in a way that failed two different ways at once: `ffmpeg` and `ffprobe` were
  **x86_64-only**, so every conversion on Apple Silicon ran through Rosetta (and failed
  outright on a Mac where Rosetta was never installed), while the app binary and `deno` were
  **arm64-only**, so an Intel Mac would install the package successfully and then be unable to
  launch it. The installer meanwhile declared `hostArchitectures="arm64,x86_64"`, which was
  simply untrue.

  `fetch-binaries.sh` now assembles every helper from both slices with `lipo`, and
  `build-installer.sh` builds with `-destination 'generic/platform=macOS'` and **verifies**
  each binary is universal rather than assuming it. Single-arch anything fails the build.

  `ffmpeg`/`ffprobe` now come from ffmpeg.martin-riedl.de, which publishes both architectures
  from the same build run — splicing two different upstream ffmpeg versions into one binary
  would report one version and behave as another depending on the host. Same licence posture
  as before: GPL v3, not `--enable-nonfree`.

  Cost of this: the package roughly doubles in size, because every binary now carries two
  slices.

### Added

- **Stash Video can check for its own updates.** Settings ▸ Updates gained a *Stash Video*
  section beside the yt-dlp one: it reads the latest published release and links to it. It
  deliberately does not self-install — the app ships as a signed installer package, and the
  release page is where an update actually comes from. A published release older than what is
  running is never offered, so a local build ahead of the release cannot be talked into a
  downgrade.

  Note: this needs a **public** repository to work. While hov172/StashVideo is private the
  unauthenticated API answers `Not Found`, which surfaces as a visible "could not check"
  rather than a silent "up to date".

- **`Scripts/bump-version.sh`** — rewrites all twelve version entries in the pbxproj and
  verifies the count, failing on a partial bump. Doing this by hand is how a bundle ends up
  reporting one version while its package claims another.

- **`Scripts/fetch-ffmpeg-source.sh`** — downloads the FFmpeg source matching the built
  binary, for attaching to a release. The GPL's source requirement is now met by an actual
  tarball on the release rather than only by a written offer that depends on us staying
  reachable.

- **CI builds the installer** on every push: an unsigned package, then checks that all four
  helpers and `GPL-3.0.txt` are in the payload, that it installs to `/Applications`, and that
  `postinstall` refuses to clobber a pre-existing Homebrew `ffmpeg` and is idempotent.

### Changed

- Version comparison moved into a shared `DottedVersion`, used by both the yt-dlp updater and
  the new app updater. `1.10.0` vs `1.9.0` is the case that string comparison gets backwards.
- Helper versions and the FFmpeg configure line are now generated **from the shipped binaries**
  at build time into `Contents/Resources/licenses/`, instead of being hand-written in
  `THIRD-PARTY-LICENSES.md` where they had already gone stale.

### Removed

- **`Scripts/download-deps.sh`**, superseded by `fetch-binaries.sh` and actively unsafe: it
  fetched yt-dlp with no checksum verification, pulled Intel-only ffmpeg while calling it
  universal, and copied a Homebrew `aria2c` — a dynamically linked binary that cannot survive
  being bundled and signed.

## [1.2.3] — 2026-08-21

### Added

- **Licensing is now explicit.** `LICENSE` covers Stash Video's own code;
  `THIRD-PARTY-LICENSES.md` covers the four programs the app ships and runs as subprocesses,
  with full texts in `licenses/`.

  The bundled FFmpeg is **GPL v3** — the evermeet.cx build is configured
  `--enable-gpl --enable-version3` (x264, x265 and other GPL components). It is *not* an
  `--enable-nonfree` build, which could not be redistributed at all. Distributing it requires
  the license text to accompany the binary and corresponding source to be available, so the
  installer now copies `licenses/` into `Contents/Resources/licenses` **before** the app is
  signed — afterwards would break the seal — and the build fails outright if `GPL-3.0.txt` is
  missing from the bundle. `THIRD-PARTY-LICENSES.md` carries the written offer for FFmpeg
  source and notes that anyone redistributing the installer inherits that obligation.

  yt-dlp is public domain (Unlicense) and Deno is MIT; both are shipped unmodified. Re-signing
  a binary changes its signature, not its code, so no "modified version" obligations attach.

## [1.2.2] — 2026-08-21

### Added

- **Installer package.** `Scripts/build-installer.sh` builds `dist/StashVideo-<version>.pkg`:
  it fetches any missing helper binaries, builds Release, signs the app and its bundled tools,
  runs `pkgbuild`/`productbuild`, then notarizes and staples the package. Version and
  minimum-OS gate are read from the pbxproj so they cannot drift from the app's.

  The package installs **Stash Video.app** into `/Applications` with `yt-dlp`, `ffmpeg`,
  `ffprobe` and `deno` inside the bundle, and its `postinstall` links the first three into
  `/usr/local/bin` for Terminal use. It never replaces a binary it didn't install — on Intel
  Macs Homebrew owns `/usr/local/bin`, and an existing `ffmpeg` there is left alone.

- **`Scripts/uninstall.sh`** — removes the app, the links this installer created, and the
  package receipt; `--all` also clears settings and cache.

### Fixed

- **Bundled `yt-dlp` could not start in a signed build.** `yt-dlp_macos` is a PyInstaller
  one-file bundle: it unpacks a private `Python.framework` at launch and `dlopen()`s it. Our
  re-signing stamped the outer executable with our Team ID while that framework kept its
  original one, and the hardened runtime's library validation refuses to map a library whose
  Team ID differs from the process — so the binary died with *"Failed to load Python shared
  library … have different Team IDs"*.

  `yt-dlp` is now signed with `Scripts/yt-dlp.entitlements`
  (`com.apple.security.cs.disable-library-validation`), the standard remedy for a re-signed
  PyInstaller tool. `ffmpeg` and `ffprobe` are static and need nothing; `deno` already had its
  JIT entitlements.

  This affected any fresh install, including 1.2.1: `DependencyResolver` prefers
  `~/Library/Application Support/…/bin`, so anyone who had run the in-app updater used an
  unmodified yt-dlp and never saw it. `Scripts/sign-app.sh` now smoke-tests every helper after
  signing, so a helper that cannot launch fails the build instead of shipping.

### Changed

- The app + helper signing steps moved out of `Scripts/notarize.sh` into
  `Scripts/sign-app.sh`, shared by both the app-only and installer routes. `notarize.sh`
  behaves the same for callers. Which helper needs which entitlements now lives in one place,
  `Scripts/tool-entitlements.sh`, sourced by both the build phase and the release signer — the
  yt-dlp bug above was possible because those two lists could drift.

## [1.2.1] — 2026-08-21

### Fixed

- **Developer ID distribution works from Xcode again.** `Resources/bin` is a folder reference, so
  Xcode copied `ffmpeg`, `ffprobe` and `yt-dlp` into the bundle unsigned and its export refused
  the archive with *"Hardened Runtime is Not Enabled"*. A **Sign Bundled Tools** build phase now
  signs every bundled helper with `--options runtime` (and `deno` with its JIT entitlements)
  after the resources are copied and before the app is signed. Both distribution routes work:
  Xcode's Organizer export and `Scripts/notarize.sh`.

  This changes no app behaviour — it only affects how a release is produced.

## [1.2.0] — 2026-08-21

Three features, plus the correctness work each of them forced.

### Added

- **Parallel downloads.** The queue runs up to `Settings ▸ Network ▸ Parallel downloads` items
  at once (1–4, default 2). Each item has its own pause, resume and cancel, and reports its own
  progress, status line and error. A failure on one row no longer touches the main window or
  the other downloads.
- **Container picker** above the format list: **Auto · MP4 preferred** (default), **MP4**,
  **MKV**, **WebM**, **Original**. The picker warns when the current selection would trigger a
  re-encode, which is the difference between a download taking seconds and taking minutes.
- **Auto also chooses the streams.** It prefers the best H.264 + AAC pair a site offers, so the
  usual result is a QuickTime-playable MP4 from a pure merge — no conversion step. Where a site
  has no H.264 it falls back to the best available in an MKV, still without an encoder. This
  caps resolution where H.264 stops (often 1080p); choose **MKV** for maximum resolution with
  no re-encode, or **MP4** for maximum resolution delivered as MP4, accepting the wait.
- **Feed subscriptions.** Watch a YouTube channel (URL, `@handle`, or playlist) or any RSS/Atom
  feed and have new uploads queue themselves. `youtube.com/channel/…` and `…/playlist?list=…`
  resolve offline; handles and vanity URLs resolve by reading the page; everything else uses
  standard `<link rel="alternate">` autodiscovery. Interval in `Settings ▸ Feeds`.
- **Queue indicator in the toolbar** — count, aggregate progress, click for the full list.
  Present in every mode, so a subscription firing while the playlist screen is up is visible.
- **TikTok creator pages** are routed to the playlist UI. `tiktok.com/@name` is a playlist to
  yt-dlp (`tiktok:user`) while `tiktok.com/@name/video/123` is one clip; the two differ by a
  single path segment, so the check parses the URL rather than matching substrings. Previously a
  profile URL was analyzed as a single video and yielded one clip instead of the creator's feed.
- **HLS streams are selectable instead of hidden.** They were filtered out of the pickers
  whenever any non-HLS format existed, which on a site publishing its higher resolutions only
  over HLS removed the only copies of them — the app offered 1080p where 4K existed, with
  nothing on screen to explain why. Delivery protocol is now a ranking signal: below resolution
  (so a genuinely better stream wins even over HLS) and above bitrate (so a muxed HLS variant,
  whose reported bitrate covers video *and* audio, cannot outrank a clean same-resolution DASH
  stream). Default selections are unchanged on sites that offer both.
- **Format pickers label the delivery protocol** — "HLS" or "DASH", nothing for a plain file.
- **Streams are paired by protocol.** An HLS video now takes HLS audio where the site publishes
  it, instead of asking ffmpeg to reconcile two segmenting schemes at merge time.
- **Reveal in Finder** on completed queue rows.
- **Vendor identity**: the Ayala Solutions mark and name in the About window, and a copyright
  string in the bundle (visible in Finder's Get Info). The app icon is unchanged — it says what
  the app does, which is what an icon in a crowded Dock is for.

### Changed

- The default container preset is now **Auto · MP4 preferred**. Previously every combined
  download was forced to H.264/AAC MP4, re-encoding whenever the source was not already — which
  is most modern sources. Downloads that used to show "Converting…" for minutes now finish in
  seconds. To restore the old behaviour, pick **MP4** in the format picker.
- The post-processing label reads "Converting…" rather than "Converting to MP4…", since the
  target container is now a choice.
- The clipboard monitor no longer refuses to analyze a copied link while a download is running.
  Analyzing uses its own subprocess and has always been allowed during downloads; with a
  parallel queue the old gate would have blocked it almost permanently.

### Fixed

- **Upgrading no longer erases your settings.** Swift's synthesized `Decodable` requires every
  key, so each field added to `Config` made an older `config.json` fail to decode — and
  `ConfigStore.load()` treats a decode failure as "corrupt, use defaults". Adding the four
  settings in this release would otherwise have reset the download folder, cookie browser,
  extension path, window geometry and everything else on first launch. `Config` now decodes
  leniently: a missing key means "this version added it" and takes that field's default,
  leaving the rest intact.
- **Feed URLs that don't look like feeds are accepted.** Bridge services and many CMSes serve
  XML from an extensionless route (`/tiktok/user/@name`, `/rss/`); those were treated as web
  pages and scraped for an autodiscovery `<link>` that XML never contains. The fetched document
  is now checked for an RSS/Atom root element first.
- **Sites with no feed report that they have none.** TikTok publishes no RSS of any kind, so
  "no feed was advertised at that address" sent the user looking for a setting that does not
  exist. It is now named, answered without a network round trip, and points at feed bridges.
- A download whose process failed to launch (a negative exit code) left its queue item marked
  as downloading forever. Harmless when one download ran at a time; with a concurrency budget it
  leaked a slot permanently. Every exit path now settles the item.
- A queue item's file modification date came from the *currently analyzed* video rather than its
  own. With several downloads in flight this would stamp files from an unrelated video. Each
  item now captures its upload date when queued.
- Cancelling after a download had already finished still signalled the retained subprocess
  handle. Sessions are now released on completion, so a stale Cancel cannot reach a later
  download.

### Internal

- `DownloadSession` holds the runner and pause/cancel intent per process; these were view-model
  fields that only worked while exactly one download existed.
- `ContainerPlanner` and `StreamSelector` are pure functions over codec names, so container and
  stream policy are testable without a subprocess.
- `SubscriptionModel` knows nothing about downloading — it reports unseen feed entries and the
  view model decides what to do with them.
- `MainViewModel` split into `+Run`, `+Queue` and `+Feeds` extensions.
- Both targets now compile with **zero warnings**. Nine test doubles were declared `@MainActor`
  *and* `@unchecked Sendable` with unguarded state — a self-contradiction the compiler flagged as
  a Swift 6 error in waiting, since `ProcessRunning` requires a nonisolated `cancel()`. They were
  also copy-paste variants of one idea, so all nine collapse into a single lock-guarded
  `ScriptedRunner`. A separate double held a lock across an `await`, fixed with scoped
  `withLock`.
- Test suite: 274 tests, up from ~196. Force-unwraps in tests replaced with `#require`, so a
  wrong expectation fails one test instead of trapping and taking the whole test host down.

## [1.0] — earlier

Initial release: analyze and download through `yt-dlp`, format/subtitle/chapter selection,
browser cookies, sequential queue with pause/resume, playlist detection, checksum-verified
in-app `yt-dlp` updates, and the Chromium extension launcher.
