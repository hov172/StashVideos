# Send to Stash Video

A one-button toolbar extension for Chrome, Brave, Edge, Chromium and Firefox. Click it on any
`http(s)` page and the page's address is handed to Stash Video, which opens with the link already
in its field and starts analyzing it. Nothing is sent anywhere else; the extension only asks for
the `activeTab` permission and never reads page content.

It is not in the Chrome Web Store or Firefox Add-ons yet, so it is loaded as an unpacked extension.

## Requirements

- Stash Video 1.9.0 or later installed on the same computer (macOS or Windows). The app
  registers the `stashvideo://` link scheme when it is installed; launch it once after installing.

## Install

1. Download this repository (**Code ▸ Download ZIP** on GitHub) and unzip it, or clone it.
   Keep the `extensions/send-to-stash-video` folder somewhere permanent; the browser loads it from
   that location every time it starts.

### Chrome, Brave, Edge, Chromium

1. Open `chrome://extensions` (`brave://extensions`, `edge://extensions`).
2. Turn on **Developer mode** (top right).
3. Click **Load unpacked** and choose the `send-to-stash-video` folder.
4. Optional: click the puzzle-piece icon in the toolbar and pin **Send to Stash Video**.

### Firefox

1. Open `about:debugging#/runtime/this-firefox`.
2. Click **Load Temporary Add-on…** and choose `manifest.json` inside the folder.

Firefox removes temporary add-ons when it quits, so repeat this after a restart. A signed build
that stays installed is planned.

## Use

1. Browse to the video or page you want.
2. Click the **Send to Stash Video** toolbar button.
3. The first time, the browser asks whether to open Stash Video. Allow it, and tick
   "always allow" if offered so later clicks go straight through.
4. Stash Video comes to the front with the link filled in and analysis under way. Pick a
   format and download as usual.

The button does nothing on pages that are not `http` or `https` (new-tab pages, browser
settings, local files).

## Troubleshooting

- **Nothing happens, or the browser says it cannot open the link** — Stash Video is not
  installed, or has never been launched since installing. Open it once, then try again.
- **Firefox refuses to load the folder** — pick the `manifest.json` file, not the folder.
- **The extension disappeared** — in Chrome, Developer mode was turned off; in Firefox, the browser
  was restarted (see above).

The bookmarklet in the main [README](../../README.md#send-a-page-from-your-browser) does the same
job in any browser, including Safari, with nothing to install.
