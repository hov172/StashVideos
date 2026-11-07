#!/bin/zsh
# Uploads the Firefox zip to addons.mozilla.org with the AMO API, the same curl recipe used for
# AS Authenticator. First run creates the add-on (listed); later runs add a version.
#
#   AMO_JWT_ISSUER=user:123:456 AMO_JWT_SECRET=… ./publish-firefox.sh [dist/send-to-stash-video-firefox-<v>.zip]
#
# Keys: https://addons.mozilla.org/developers/addon/api/key/   Slug after creation: send-to-stash-video
set -euo pipefail
cd "$(dirname "$0")"
: "${AMO_JWT_ISSUER:?set AMO_JWT_ISSUER}" "${AMO_JWT_SECRET:?set AMO_JWT_SECRET}"
ZIP="${1:-$(ls dist/send-to-stash-video-firefox-*.zip | tail -1)}"
SLUG=send-to-stash-video
api=https://addons.mozilla.org/api/v5
b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }
jwt() { local now h p; now=$(date +%s); h=$(printf '{"alg":"HS256","typ":"JWT"}' | b64url)
  p=$(printf '{"iss":"%s","jti":"%s","iat":%s,"exp":%s}' "$AMO_JWT_ISSUER" "$(uuidgen)" "$now" "$((now + 60))" | b64url)
  printf '%s.%s.%s' "$h" "$p" "$(printf '%s.%s' "$h" "$p" | openssl dgst -sha256 -hmac "$AMO_JWT_SECRET" -binary | b64url)"; }

echo "▶ Uploading $ZIP"
up=$(curl -sS --proto '=https' -H "Authorization: JWT $(jwt)" -F "upload=@$ZIP" -F channel=listed "$api/addons/upload/")
uuid=$(echo "$up" | jq -r .uuid); [ -n "$uuid" ] && [ "$uuid" != null ] || { echo "upload was not accepted: $up"; exit 1; }
echo "▶ Waiting for validation"
for i in $(seq 1 30); do
  st=$(curl -sS --fail-with-body -H "Authorization: JWT $(jwt)" "$api/addons/upload/$uuid/")
  [ "$(echo "$st" | jq -r .processed)" = true ] && break; sleep 10
done
echo "$st" | jq -e '.valid == true' >/dev/null || { echo "validation failed:"; echo "$st" | jq .validation; exit 1; }

notes="Unminified, no build step: background.js and manifest.json are the source. Chrome and Firefox zips are produced by package.sh in https://github.com/hov172/StashVideos/tree/main/extensions/send-to-stash-video"
if curl -sS -o /dev/null -w '%{http_code}' -H "Authorization: JWT $(jwt)" "$api/addons/addon/$SLUG/" | grep -q 200; then
  echo "▶ Add-on exists: creating a new version"
  out=$(curl -sS -w "\nHTTP %{http_code}" -H "Authorization: JWT $(jwt)" -F "upload=$uuid" -F "approval_notes=$notes" \
       -F "release_notes[en-US]=See CHANGELOG.md in the repository." "$api/addons/addon/$SLUG/versions/")
else
  echo "▶ First submission: creating the add-on"
  out=$(curl -sS -w "\nHTTP %{http_code}" -H "Authorization: JWT $(jwt)" \
       -F "version[upload]=$uuid" -F "version[approval_notes]=$notes" -F "version[license]=MIT" \
       -F "slug=$SLUG" -F "categories[firefox][]=download-management" \
       -F "summary[en-US]=One-click handoff of the page you are on to the Stash Video app, which analyzes the link and offers every stream the site has for download." \
       -F "homepage[en-US]=https://github.com/hov172/StashVideos" -F "support_url[en-US]=https://github.com/hov172/StashVideos/issues" \
       "$api/addons/addon/")
fi
status=$(echo "$out" | tail -1); body=$(echo "$out" | sed '$d')
case "$status" in "HTTP 2"*) ;; *) echo "AMO refused ($status):"; echo "$body" | jq . 2>/dev/null || echo "$body"; exit 1 ;; esac
echo "$body" | jq '{id, slug, version: (.version // .current_version), url}' 2>/dev/null || echo "$body"
echo "Done. Finish the listing text (description, screenshot) at https://addons.mozilla.org/developers/addon/$SLUG/edit"
