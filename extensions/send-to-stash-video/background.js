// The browser this copy runs in, as yt-dlp's --cookies-from-browser names it, so Stash Video
// can use the session the page was signed in with. Chromium brands hide behind the Chrome
// listing, so the user agent tells them apart.
function sendingBrowser() {
  const ua = navigator.userAgent;
  if (/Firefox\//.test(ua)) return "firefox";
  if (/Edg\//.test(ua)) return "edge";
  if (/OPR\//.test(ua)) return "opera";
  if (/Vivaldi\//.test(ua)) return "vivaldi";
  if (navigator.brave) return "brave";
  if (/Safari\//.test(ua) && !/Chrome\//.test(ua)) return "safari";
  return "chrome";
}

// Hands the current tab's URL to Stash Video via its stashvideo:// scheme.
chrome.action.onClicked.addListener(async (tab) => {
  if (!tab.url || !/^https?:/i.test(tab.url)) return;
  const target = "stashvideo://open?url=" + encodeURIComponent(tab.url) + "&browser=" + sendingBrowser();
  // Safari build only: the manifest grants nativeMessaging and the app extension opens the link,
  // because Safari will not navigate a tab to a custom scheme.
  if ((chrome.runtime.getManifest().permissions || []).includes("nativeMessaging")) {
    await chrome.runtime.sendNativeMessage("app", { open: target });
    return;
  }
  try {
    await chrome.tabs.update(tab.id, { url: target });
  } catch (e) {
    // Firefox may refuse non-web schemes on an existing tab: open a throwaway tab instead.
    const t = await chrome.tabs.create({ url: target, active: false });
    setTimeout(() => chrome.tabs.remove(t.id).catch(() => {}), 1000);
  }
});

// First install: open the download page once, so nobody clicks the button without the app
// (the browser gives no error when nothing handles stashvideo://).
chrome.runtime.onInstalled.addListener(({ reason }) => {
  if (reason !== "install") return;
  chrome.tabs.create({ url: "https://github.com/hov172/StashVideos#send-a-page-from-your-browser" });
});
