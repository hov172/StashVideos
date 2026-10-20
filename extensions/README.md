# Send to Stash Video

Sends the page you are looking at to the Stash Video app, which analyzes it. The app must be installed
(it registers the `stashvideo://` link scheme); it need not be running.

## Bookmarklet (every browser, no install)

Create a bookmark whose URL is:

```
javascript:location.href='stashvideo://open?url='+encodeURIComponent(location.href)
```

Click it on any page.

## Browser extension (Chrome, Edge, Brave, Firefox 121+)

The `send-to-stash-video/` folder is a Manifest V3 extension; its toolbar button sends the current tab.

- Chrome/Edge/Brave: `chrome://extensions` > Developer mode > Load unpacked > pick `send-to-stash-video`.
- Firefox: `about:debugging#/runtime/this-firefox` > Load Temporary Add-on > pick its `manifest.json`.

## Safari

There is no Safari extension yet: use the bookmarklet above. The sources for the planned Safari Web
Extension target and the steps to add it to the Xcode project are in [safari/README.md](safari/README.md).
