// Hands the current tab's URL to Stash Video via its stashvideo:// scheme.
chrome.action.onClicked.addListener(async (tab) => {
  if (!tab.url || !/^https?:/i.test(tab.url)) return;
  const target = "stashvideo://open?url=" + encodeURIComponent(tab.url);
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
