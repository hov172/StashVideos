<img src="docs/assets/ayala-solutions-mark.png" alt="Ayala Solutions" height="56" align="left">

# Stash Video

**by Ayala Solutions**

<br clear="left">

Native macOS and Windows front ends for [`yt-dlp`](https://github.com/yt-dlp/yt-dlp). Paste a link,
pick a quality, get a file — with a parallel download queue, container presets that avoid needless
re-encoding, and feed subscriptions that download new uploads on their own. Both apps share the
same features, settings and languages; the differences are listed where they matter below.

## Content Owner Permission Required

**Do not use Stash Video to download videos without permission from the content owner.**

**Current version: 1.7.4** (macOS build 23; Windows test build 3). See the [latest release](https://github.com/hov172/StashVideos/releases/latest) and the [changelog](CHANGELOG.md).

---

## Requirements

| | macOS | Windows |
|---|---|---|
| Version | 14.0 or later | 10 version 2004 (build 19041) or later, including 11 |
| Architecture | Apple Silicon or Intel — the app and every bundled tool are universal | x64 or arm64 — one installer, the native build is installed |
| Disk | ~600 MB installed — the helper tools carry both architectures | ~340 MB download |
| Signing | Developer ID signed and notarized | Not yet code-signed — see [Windows](#windows-test-build) |

Both apps bundle their own `yt-dlp`, `ffmpeg`, `ffprobe` and `deno`, so nothing else needs to be
installed. On macOS the installer additionally links `yt-dlp`, `ffmpeg` and `ffprobe` into
`/usr/local/bin` so they work from Terminal — it never replaces anything already there, so an
existing Homebrew `ffmpeg` is left alone. The bundled uninstaller removes both the app and those links.

## Install

> This repository holds Stash Video's releases, release notes and licenses for both platforms. The apps'
> source is not published. The in-app **Settings ▸ Updates** check on either platform reads this
> repository's release feed.

Every release carries the macOS package (`StashVideo-<version>-<date>.pkg`) and the Windows installer
(`StashVideo-Setup-<version>.exe`). Verify downloads against the SHA-256 values in the release notes.

### macOS

**Download the installer** from the [latest release](https://github.com/hov172/StashVideos/releases/latest)
and open it. It puts Stash Video in `/Applications` with `yt-dlp`, `ffmpeg`, `ffprobe` and
`deno` already inside — nothing else to install. The package is signed and notarized, so it
opens without a Gatekeeper warning, and it's a universal binary: native on both Apple Silicon
and Intel.

#### Or install with Homebrew

```bash
brew tap hov172/stashvideos https://github.com/hov172/StashVideos
brew trust hov172/stashvideos
brew install --cask stash-video
```

The `brew trust` step is Homebrew's one-time confirmation for any third-party tap. This installs the same signed, notarized package as the release page; `brew upgrade --cask stash-video`
picks up new releases and `brew uninstall --cask stash-video` removes the app and the links it made.

### Windows (test build)

Stash Video for Windows is a separate app with the same features. Its installer is not yet code-signed,
so SmartScreen warns about it; no certificate import is needed.

1. Download `StashVideo-Setup-<version>.exe` from the
   [latest release](https://github.com/hov172/StashVideos/releases/latest).
2. Run it. When SmartScreen shows "Windows protected your PC", choose **More info → Run anyway**, then
   approve the administrator prompt. It installs for all users under `C:\Program Files\Stash Video` and
   bundles `yt-dlp`, `ffmpeg`, `ffprobe` and `deno`; nothing else to install.

Uninstall from **Settings → Apps**. Your settings and history stay in `%LOCALAPPDATA%\StashVideo`.

**If you installed an earlier Windows test build** (the one that needed `StashVideo-test-signing.cer`),
uninstall it from Settings → Apps first; Windows treats it as a different app. Then remove its
certificate in an elevated PowerShell:

```powershell
Get-ChildItem Cert:\LocalMachine\TrustedPeople | Where-Object Subject -eq 'CN=Ayala Solutions' | Remove-Item
```

Windows test builds are tried on one Windows 11 x64 PC before release; a clean PC and arm64 hardware
are not yet part of the checks. Please report anything that fails.

### Updating

`Settings ▸ Updates ▸ Check Now` looks for a newer release; the app also checks at every launch
(`Settings ▸ Updates ▸ Automatically check for updates`) and shows a banner.

**On Windows**, the banner's **Install** downloads that release's `StashVideo-Setup-<version>.exe` from this
repository, closes the app and runs the installer silently — expect one administrator prompt — and the new
version reopens when it finishes. Running the downloaded Setup.exe yourself does the same thing.

**On macOS**, **Install Update…** downloads the release's installer and installs it
through the bundled Stash Video Updater, so a standard user can update without an administrator
password. It needs a one-time setup: **Set Up Self-Service Updates…** registers the updater, and
an administrator approves `Stash Video Updater` under `System Settings ▸ General ▸ Login Items &
Extensions`. On managed Macs, the profile in [`mdm/`](mdm/) pre-approves it so no one has to.

The updater only ever receives a version number. It fetches that release from this project's
public release page, requires the package to be signed by Stash Video's Developer ID Installer
certificate and accepted by Gatekeeper, and checks that it is the Stash Video installer for
exactly that version before running the macOS installer. Installing quits a running Stash Video
first and reopens it afterwards. Homebrew users can keep using `brew upgrade --cask stash-video`
instead.

On both platforms the same launch check looks for a newer `yt-dlp`. With `Install yt-dlp updates automatically` on,
the main window shows "Updating yt-dlp to <version>…" with a spinner for the few seconds it takes;
with it off, the banner offers **Update Now** and installs when you press it. The download is verified
against yt-dlp's published `SHA2-256SUMS` before it replaces anything.

### Uninstalling

**Windows:** Settings ▸ Apps ▸ Stash Video ▸ Uninstall. It removes the program folder, Start menu entry
and uninstall entry, and keeps your settings, history and updated `yt-dlp` in `%LOCALAPPDATA%\StashVideo`.

**macOS:** open **StashVideo-Uninstaller.pkg**, inside the app at
`Stash Video.app/Contents/Resources/`, or download it from the
[release](https://github.com/hov172/StashVideos/releases/latest). It removes the app, the
`/usr/local/bin` links and the package receipts — leaving anything it did not install (a
Homebrew `ffmpeg`, for instance) alone, and keeping your settings and downloads.

To find the one inside the app: right-click Stash Video in Applications, choose **Show Package
Contents**, then open `Contents/Resources`.

The app and every bundled tool are universal (arm64 + x86_64), so one package runs natively on
both Apple Silicon and Intel — no Rosetta. The build fails rather than producing a single-arch
package.

## First run

If `yt-dlp` or `ffmpeg` can't be found, the app opens to a **Setup** screen and offers to locate
them. It looks where in-app updates land first (Application Support on macOS,
`%LOCALAPPDATA%\StashVideo\bin` on Windows), then the bundled copies, then Homebrew and your `PATH` —
so point it somewhere else only if you keep them elsewhere.

macOS will not open a build it can't verify. For a locally built copy that is not an issue; for
one downloaded from someone else, right-click ▸ Open the first time, or the app must be notarized.

## Using it

### Download a video

1. Get a link into the app — paste it in the toolbar field, **drag** it onto the window, or turn
   on `Settings ▸ General ▸ Monitor clipboard` and just copy it.
2. Press **Analyze** (or Return). The app fetches the media info; **Stop** aborts a slow one.
3. Pick a **Format**, **Video**, **Audio**, and optionally a subtitle or chapter.
4. Choose where it goes, then **Download** — or **Add to Queue** and line up the next link.

### Audio only

**Save Audio Only…** sits beside Download. Its save dialog has a **Format** popup: M4A (AAC),
ALAC (Apple Lossless), MP3, Opus, FLAC, WAV or AIFF. The popup decides the format even if you
edit the file extension by hand. AIFF is extracted as WAV and converted by the bundled FFmpeg.

### Format: the one choice that matters

The **Format** row sits above the streams because it decides whether a download takes seconds or
minutes.

| Preset | What you get | Re-encodes? |
|---|---|---|
| **Auto · MP4 preferred** *(default)* | Picks the best H.264 + AAC pair the site has, so the result is an MP4 from a straight merge. Falls back to MKV where a site has no H.264. | **Never** |
| **MP4** | Always MP4, at the highest resolution available — re-encoding when the source isn't already H.264/AAC. | Often |
| **MKV** | Highest resolution, always a lossless merge. Plays in VLC, IINA or Windows' Media Player rather than QuickTime. | Never |
| **WebM** | Keeps VP9/AV1 + Opus as-is. | For anything else |
| **Original** | Whatever yt-dlp produces. No container forced. | Never |

Auto's trade: H.264 usually stops at 1080p where VP9/AV1 go to 4K. For maximum resolution pick
**MKV** (no wait) or **MP4** (accepts the wait). The picker warns whenever your current selection
would trigger a conversion, and the progress panel shows *"Converting…"* while one is running.

### The queue

**Add to Queue** stages a download and clears the form for the next link. Up to
`Settings ▸ Network ▸ Parallel downloads` items run at once (1–4, default 2).

Each row has its own pause, resume, cancel and progress, and its own error — one bad link never
disturbs the others or the main window. A paused download keeps its private working directory and resumes with
`--continue`; a cancelled one discards only that directory. Existing destination files are never
overwritten. If a completed file already exists, the app adds a number such as `Name (2).m4a`. If saving fails after downloading,
the job pauses and retains its files: resolve the destination problem and choose **Resume** to
retry saving without another download. Files already saved are preserved.

The toolbar's queue button shows the count and combined progress from any screen, and opens the
full list. Direct downloads, individual streams, playlists, and feeds share the same limit.
Paused jobs reserve their destination; conflicting jobs wait. Quitting cancels all work and
discards paused working directories, so pause/resume lasts for the current app session.

### Playlists and creator pages

A playlist URL switches to a checklist of entries, each downloading with its own progress. Creator
pages whose extractor returns a playlist work the same way — a TikTok profile lists that
creator's videos, while a single TikTok video URL still downloads as one clip.

Supported video catalogs also open as searchable checklists, letting you select videos and
download them through the shared queue. Collection support depends on the site.

### Feed subscriptions

Toolbar ▸ the antenna button. Paste a channel or feed URL, pick a quality, and new uploads queue
themselves.

- `youtube.com/channel/UC…` and `youtube.com/playlist?list=…` resolve offline — the id is in the URL.
- `@handle`, `/c/…` and `/user/…` carry no id, so the page is fetched once and the id read from it.
- Anything else is used as a feed URL, or discovered from the page's
  `<link rel="alternate" type="application/rss+xml">` tag.

Subscribing records the feed's current window as already seen, so it starts from the **next**
upload rather than the back catalogue. Videos land in `<download folder>/<subscription>/`, and
checks run on the interval in `Settings ▸ Feeds`. An entry is marked seen *before* its download
is attempted, so one permanently broken video can't be retried on every poll — the row menu's
**Re-download Recent Videos** clears that memory for a feed.

Some sites publish no feed at all (TikTok among them). Those are named as such, and can be
subscribed through a feed bridge — paste the bridge's URL. Bridge routes usually serve XML from a
path with no `.xml` on the end; that is recognised from the document, so the URL needn't look
like a feed.

### History

The clock button lists completed downloads. Click one to load its link back into the app.

### Language

Stash Video follows your system language (14 languages: English, German, Greek, Spanish, French,
Italian, Japanese, Korean, Polish, Portuguese (Brazil), Russian, Ukrainian, Simplified and Traditional
Chinese). The toolbar's globe menu picks a different language for this app only; the change applies
the next time the app opens.

## Settings (⌘, on macOS, Ctrl+, on Windows)

| Tab | What's in it |
|---|---|
| **General** | Appearance (Dark by default, Light, or System), window behaviour (always on top, remember position/size; UI scale on macOS), auto-download after analyze, clipboard monitoring, hardware-accelerated encoding (VideoToolbox on macOS; NVENC, Quick Sync or AMF on Windows, whichever the PC has), completion notifications and sound |
| **Network** | Parallel downloads, proxy, aria2c, rate limit |
| **Cookies** | Cookie policy (when to use them) and which browser to take them from (Chrome, Edge, Firefox, Brave, Vivaldi, Opera or Chromium) |
| **Media** | Thumbnail saving/embedding, chapter and subtitle embedding, filename template, modified date, time range, temp folder, config file |
| **Feeds** | Background checking on/off and how often |
| **Browser** | Launch Chrome, Brave, Edge or Chromium (or any executable you pick) with an unpacked extension in an isolated, throwaway profile |
| **Updates** | Check for a newer Stash Video release (also at every launch, with a banner) and install it — without an administrator password on macOS once self-service updates are set up, with one administrator prompt on Windows — and check for and install newer `yt-dlp`, verified against `SHA2-256SUMS` |

## Troubleshooting

<details>
<summary><b>It says "Converting…" and takes minutes</b></summary>

The **MP4** preset re-encodes anything that isn't already H.264/AAC, which above 1080p is most
sources. Switch **Format** to **Auto** — it merges instead, in seconds. Files from VP9/AV1-only
sites will be `.mkv`; VLC and IINA play them, QuickTime doesn't.
</details>

<details>
<summary><b>There's a stray .jpg next to every video</b></summary>

`Settings ▸ Media ▸ Save thumbnail` is on by default. Turn it off, or turn on **Embed thumbnail**
to put the artwork inside the file instead. WAV and AIFF cannot hold artwork, so an audio-only
download in those formats keeps the JPEG beside the file even with **Embed thumbnail** on.
</details>

<details>
<summary><b>Several files appear while downloading, then vanish</b></summary>

Expected inside the private `.stash-download-…` working directory. Video and audio arrive as separate streams (`video.f137.mp4`, `video.f140.m4a`), get
merged, and the fragments are deleted. That's also why there are two progress bars.
</details>

<details>
<summary><b>"This video requires sign-in cookies"</b></summary>

Pick the browser you're signed in with under `Settings ▸ Cookies` (or the toolbar's key menu) and
analyze again. macOS may ask for Keychain permission the first time. On Windows, recent Chrome
versions lock their cookie store so that yt-dlp cannot read it; Firefox, or Edge or Brave, works when
Chrome does not.
</details>

<details>
<summary><b>"This site is blocking automated requests"</b></summary>

The site rejected yt-dlp's HTTP fingerprint (403). The app retries automatically impersonating a
browser. If it reports that impersonation isn't available, update `yt-dlp` in `Settings ▸ Updates`.
</details>

<details>
<summary><b>"Unsupported URL"</b></summary>

The app then fetches the page itself and looks for an embedded player, which covers wrapper pages
like Panopto. If that finds nothing, the site likely needs an upstream yt-dlp fix — try
`Settings ▸ Updates` first.
</details>

<details>
<summary><b>LinkedIn Learning: "No video formats found"</b></summary>

LinkedIn sometimes returns lesson metadata without playable media URLs. If the lesson plays in
Chrome: DevTools ▸ Network ▸ Preserve log, filter `m3u8`, reload and press Play, then paste the
full `.m3u8` **playlist** URL into Stash Video.

Copy the playlist URL, not a `.ts` segment — segment URLs usually contain a numeric path
component like `/37/…` and yield only a few seconds of media.
</details>

## How it works

Stash Video shells out to `yt-dlp` and `ffmpeg` rather than reimplementing them, so it supports
whatever the installed `yt-dlp` supports (~1,750 extractors) and improves whenever yt-dlp does.
The Mac app uses Developer ID distribution with App Sandbox disabled for its current helper,
browser-cookie, and filesystem access design. The Windows app is a WinUI 3 desktop app installed
the ordinary way under Program Files (no MSIX or Store packaging), and writes only to
`%LOCALAPPDATA%\StashVideo`.

Beyond a plain wrapper, it adds browser-cookie retries for sign-in walls, browser impersonation
for bot blocks, embedded-player resolution for wrapper pages, checksum-verified in-app `yt-dlp`
updates, and the queue, container and subscription behaviour above.

## License

Stash Video's own code is proprietary — see [LICENSE](LICENSE).

It is distributed alongside three independent programs that carry their own licenses:
[yt-dlp](https://github.com/yt-dlp/yt-dlp) (Unlicense), [FFmpeg](https://ffmpeg.org)
(**GPL v3** — the bundled build is configured `--enable-gpl --enable-version3`) and
[Deno](https://deno.land) (MIT). They run as separate processes rather than being linked in,
so their terms govern them and not this app.

FFmpeg's GPL carries real obligations if you redistribute the installer yourself — the
license text must travel with the binary, and corresponding source must be available.
[THIRD-PARTY-LICENSES.md](THIRD-PARTY-LICENSES.md) spells out both, and the full texts are in
[`licenses/`](licenses/) and inside the installed app — `Contents/Resources/licenses` on macOS,
`Assets\licenses` under `C:\Program Files\Stash Video` on Windows. Each release also attaches the
exact FFmpeg source the Windows build was made from.
