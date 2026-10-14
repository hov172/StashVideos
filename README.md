<img src="docs/assets/ayala-solutions-mark.png" alt="Ayala Solutions" height="56" align="left">

# Stash Video

**by Ayala Solutions**

<br clear="left">

A native macOS front end for [`yt-dlp`](https://github.com/yt-dlp/yt-dlp). Paste a link, pick a
quality, get a file — with a parallel download queue, container presets that avoid needless
re-encoding, and feed subscriptions that download new uploads on their own.

## Content Owner Permission Required

**Do not use Stash Video to download videos without permission from the content owner.**

**Current version: 1.7.0 (build 19).** See the [latest release](https://github.com/hov172/StashVideos/releases/latest) and the [changelog](CHANGELOG.md).

---

## Requirements

| | |
|---|---|
| macOS | 14.0 or later |
| Architecture | Apple Silicon or Intel — the app and every bundled tool are universal |
| Disk | ~600 MB installed — the helper tools carry both architectures |

The app bundles its own `yt-dlp`, `ffmpeg`, `ffprobe` and `deno`, so nothing needs to be
installed with Homebrew. The installer additionally links `yt-dlp`, `ffmpeg` and `ffprobe` into
`/usr/local/bin` so they work from Terminal — it never replaces anything already there, so an
existing Homebrew `ffmpeg` is left alone. The bundled uninstaller removes both the app and those links.

## Install

> This repository holds Stash Video's releases, release notes and licenses. The app's source is not published.

**Download the installer** from the [latest release](https://github.com/hov172/StashVideos/releases/latest)
and open it. It puts Stash Video in `/Applications` with `yt-dlp`, `ffmpeg`, `ffprobe` and
`deno` already inside — nothing else to install. The package is signed and notarized, so it
opens without a Gatekeeper warning, and it's a universal binary: native on both Apple Silicon
and Intel.

Source code is kept in a private repository; this repository hosts the releases, release
notes and licensing material. The in-app **Settings ▸ Updates** check reads this
repository's release feed.

### Or install with Homebrew

```bash
brew tap hov172/stashvideos https://github.com/hov172/StashVideos
brew trust hov172/stashvideos
brew install --cask stash-video
```

The `brew trust` step is Homebrew's one-time confirmation for any third-party tap. This installs the same signed, notarized package as the release page; `brew upgrade --cask stash-video`
picks up new releases and `brew uninstall --cask stash-video` removes the app and the links it made.

### Uninstalling

Open **StashVideo-Uninstaller.pkg**, inside the app at
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
them. It looks in Application Support first (where in-app updates land), then the bundled copies,
then Homebrew and your `PATH` — so point it somewhere else only if you keep them elsewhere.

macOS will not open a build it can't verify. For a locally built copy that is not an issue; for
one downloaded from someone else, right-click ▸ Open the first time, or the app must be notarized.

## Using it

### Download a video

1. Get a link into the app — paste it in the toolbar field, **drag** it onto the window, or turn
   on `Settings ▸ General ▸ Monitor clipboard` and just copy it.
2. Press **Analyze** (or Return). The app fetches the media info; **Stop** aborts a slow one.
3. Pick a **Format**, **Video**, **Audio**, and optionally a subtitle or chapter.
4. Choose where it goes, then **Download** — or **Add to Queue** and line up the next link.

### Format: the one choice that matters

The **Format** row sits above the streams because it decides whether a download takes seconds or
minutes.

| Preset | What you get | Re-encodes? |
|---|---|---|
| **Auto · MP4 preferred** *(default)* | Picks the best H.264 + AAC pair the site has, so the result is an MP4 from a straight merge. Falls back to MKV where a site has no H.264. | **Never** |
| **MP4** | Always MP4, at the highest resolution available — re-encoding when the source isn't already H.264/AAC. | Often |
| **MKV** | Highest resolution, always a lossless merge. Needs VLC or IINA rather than QuickTime. | Never |
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

Stash Video follows your Mac's language. The toolbar's globe menu picks a different language
for this app only; the change applies the next time the app opens.

## Settings (⌘,)

| Tab | What's in it |
|---|---|
| **General** | Appearance (Dark by default, Light, or System), window behaviour (always on top, remember position/size, UI scale), auto-download after analyze, clipboard monitoring, hardware-accelerated encoding, completion notifications and sound |
| **Network** | Parallel downloads, proxy, aria2c, rate limit |
| **Cookies** | Cookie policy (when to use them) and which browser to take them from |
| **Media** | Thumbnail saving/embedding, chapter and subtitle embedding, filename template, modified date, time range, temp folder, config file |
| **Feeds** | Background checking on/off and how often |
| **Browser** | Chromium launch with an unpacked extension and an isolated profile |
| **Updates** | Check for a newer Stash Video release (also once a day at launch, with a banner linking to the release page), and check for and install newer `yt-dlp`, verified against `SHA2-256SUMS` |

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
to put the artwork inside the file instead.
</details>

<details>
<summary><b>Several files appear while downloading, then vanish</b></summary>

Expected inside the private `.stash-download-…` working directory. Video and audio arrive as separate streams (`video.f137.mp4`, `video.f140.m4a`), get
merged, and the fragments are deleted. That's also why there are two progress bars.
</details>

<details>
<summary><b>"This video requires sign-in cookies"</b></summary>

Pick the browser you're signed in with under `Settings ▸ Cookies` (or the toolbar's key menu) and
analyze again. macOS may ask for Keychain permission the first time.
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
The app uses Developer ID distribution with App Sandbox disabled for its current helper,
browser-cookie, and filesystem access design.

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
[`licenses/`](licenses/) and inside the installed app at `Contents/Resources/licenses`.
