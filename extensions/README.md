# Send to Stash Video

Sends the page you are looking at to the Stash Video app, which analyzes it. The app must be installed
(it registers the `stashvideo://` link scheme); it need not be running.

## Bookmarklet (every browser, no install)

Create a bookmark whose URL is:

```
javascript:location.href='stashvideo://open?url='+encodeURIComponent(location.href)
```

Click it on any page.

## Browser extension (Chrome, Edge, Brave, Vivaldi, Opera, Firefox 142+)

The `send-to-stash-video/` folder is a Manifest V3 extension; its toolbar button sends the current tab.
The private Mac repository carries the same folder; keep the two in step. `send-to-stash-video/package.sh`
builds the Chrome Web Store and Firefox Add-ons zips, `send-to-stash-video/STORE-LISTING.md` holds the
listing copy and submission notes, and `send-to-stash-video/publish-firefox.sh` uploads a new version to
Firefox Add-ons.

Users install from the stores: [Chrome Web Store](https://chromewebstore.google.com/detail/bfdkgjjlkmfggabaemhmbjbolmoldbll)
(all Chromium browsers) and [Firefox Add-ons](https://addons.mozilla.org/firefox/addon/send-to-stash-video/).
For development, load the folder unpacked:

- Chrome/Edge/Brave: `chrome://extensions` > Developer mode > Load unpacked > pick `send-to-stash-video`.
- Firefox: `about:debugging#/runtime/this-firefox` > Load Temporary Add-on > pick its `manifest.json`.

## Safari

Built into Stash Video 2.0.1 and later. Turn on **Send to Stash Video** in Safari ▸ Settings ▸ Extensions
and allow it on the sites you use; Settings ▸ Browser in the app shows whether it is on.
