# Store listing — Send to Stash Video

Copy for the Chrome Web Store and addons.mozilla.org (AMO) forms. Build the uploads with
`./package.sh`; it writes `dist/send-to-stash-video-chrome-<v>.zip`,
`dist/send-to-stash-video-firefox-<v>.zip` and the images under `dist/store-assets/`.

## Name

Send to Stash Video

## Summary (AMO, ≤ 250 chars; Chrome short description, ≤ 132 chars)

One-click handoff of the page you are on to the Stash Video app, which analyzes the link and
offers every stream the site has for download.

## Description

Send to Stash Video adds one toolbar button. Click it on any video page and Stash Video, the
native yt-dlp front end for macOS and Windows, opens with that link already filled in and
analyzed. Pick a format and download. No copying, no pasting, no switching apps.

It replaces the copy-link, switch-app, paste, Analyze routine with a single click.

Requires Stash Video 1.9.0 or later, free from https://github.com/hov172/StashVideos/releases.
The button does nothing on pages that are not http or https.

Use Stash Video only to download your own videos, or videos whose owner has given you permission.

## Category

Chrome Web Store: Productivity ▸ Tools. AMO: Download Management.

## Single purpose (Chrome)

Hand the current tab's address to the Stash Video desktop app via its `stashvideo://` link scheme.

## Permission justifications (Chrome)

- **activeTab** — the only permission. It supplies the current tab's URL at the moment the user
  clicks the button, so the extension can pass that URL to Stash Video. The extension never reads
  page content, never runs on pages by itself and holds no host permissions.

## Remote code (Chrome)

No. All code ships in the package; nothing is fetched or evaluated at runtime.

## Data use / privacy (Chrome "Privacy practices" tab and AMO data-collection question)

Collects no user data. The page URL goes only to the Stash Video app on the same computer, via the
operating system's link handler, and is never sent to the developer or any third party.
Tick none of the data categories. Certify: not sold, not used outside the single purpose, not used
for creditworthiness or lending.

Privacy policy URL: https://github.com/hov172/StashVideos/blob/main/extensions/send-to-stash-video/STORE-LISTING.md#privacy-policy

## Privacy policy

Send to Stash Video does not collect, store or transmit any personal data. When the user clicks
the toolbar button, the address of the current tab is passed to the Stash Video application
installed on the same computer, using the `stashvideo://` link scheme. Nothing is sent to Ayala
Solutions or to any other party. The extension has no analytics, no accounts and no remote
servers.

## Support and homepage

Homepage / support URL: https://github.com/hov172/StashVideos
Issues: https://github.com/hov172/StashVideos/issues

## Images

| Store field | File |
|---|---|
| Chrome screenshot (1280×800, required) · AMO screenshot | `dist/store-assets/screenshot-1280x800.png` |
| Chrome small promo tile (440×280) | `dist/store-assets/promo-440x280.png` |
| Chrome marquee (1400×560, optional) | `dist/store-assets/promo-1400x560.png` |
| Icon (128×128) | `icons/128.png` |

## Firefox submission notes

- Submit through https://addons.mozilla.org/developers/ with the Firefox zip. "On this site"
  gives a public listing; "On your own" signs it for self-distribution and returns a `.xpi` to
  attach to a GitHub release.
- The manifest already declares `data_collection_permissions: none`, which AMO requires.
- Lint before upload: `npx addons-linter dist/send-to-stash-video-firefox-<v>.zip`.

## Chrome Web Store submission notes

- https://chrome.google.com/webstore/devconsole — one-time developer registration fee.
- Upload the Chrome zip, fill the fields above, set visibility Public, submit for review.
- The same zip is accepted by Microsoft Partner Center for Edge Add-ons.
