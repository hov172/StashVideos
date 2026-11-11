# Send to Stash Video

A one-button toolbar extension for Chrome, Brave, Edge, Vivaldi, Opera and Firefox. Click it on any
`http(s)` page and the page's address is handed to Stash Video, which opens with the link already
in its field and starts analyzing it. Nothing is sent anywhere else; the extension only asks for
the `activeTab` permission and never reads page content.

Install it from the [Chrome Web Store](https://chromewebstore.google.com/detail/bfdkgjjlkmfggabaemhmbjbolmoldbll)
(also works in Brave, Edge, Vivaldi, Opera and other Chromium browsers) or from
[Firefox Add-ons](https://addons.mozilla.org/firefox/addon/send-to-stash-video/). Safari users do not need
this folder: the Safari version is built into Stash Video 2.0.1 and later; turn it on in Safari ▸ Settings ▸
Extensions.

## Use

1. Open a video page.
2. Click the **Send to Stash Video** toolbar button (in Chrome, pin it first from the puzzle-piece menu).
3. The first time, the browser asks whether to open Stash Video. Allow it, and tick
   "always allow" if offered so later clicks go straight through.
4. Stash Video comes to the front with the link filled in and analyzed. Choose a format and download.

From version 1.0.3 the link also names the browser it was sent from, and Stash Video 2.0.1 or later
uses that browser's cookies for the page, so a site you are signed in to in the browser needs no
second sign-in in the app (macOS asks once for Keychain access to the browser's cookie store).
Nothing about the permissions changes: the browser name comes from the user agent, and the cookies
are read by yt-dlp on your computer the same way the Settings › Cookies browser choice already works.

The button does nothing on pages that are not `http` or `https` (new-tab pages, browser
settings, local files).

## Requirements

- Stash Video 1.9.0 or later installed on the same computer (macOS or Windows); 2.0.1 or later for
  the sign-in carry-over and the built-in Safari extension. The app registers the `stashvideo://`
  link scheme when it is installed; launch it once after installing.

## Load unpacked (development only)

Normal users install from the stores linked above. To run the folder from source:

### Chrome, Brave, Edge, Chromium

1. Open `chrome://extensions` (`brave://extensions`, `edge://extensions`).
2. Turn on **Developer mode** (top right).
3. Click **Load unpacked** and choose the `send-to-stash-video` folder.
4. Optional: click the puzzle-piece icon in the toolbar and pin **Send to Stash Video**.

### Firefox

1. Open `about:debugging#/runtime/this-firefox`.
2. Click **Load Temporary Add-on…** and choose `manifest.json` inside the folder.

Firefox removes temporary add-ons when it quits, so repeat this after a restart. If Firefox
refuses to load the folder, pick the `manifest.json` file, not the folder. If the extension
disappears, Chrome's Developer mode was turned off or Firefox was restarted.

Store submissions are prepared with `./package.sh`; see [STORE-LISTING.md](STORE-LISTING.md).

## Troubleshooting

- **Nothing happens, or the browser says it cannot open the link** — Stash Video is not
  installed, or has never been launched since installing. Open it once, then try again.

The bookmarklet in the main [README](../../README.md#send-a-page-from-your-browser) does the same
job in any browser, including Safari, with nothing to install.
