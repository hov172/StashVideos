#!/bin/zsh
# Builds the store uploads for the Send to Stash Video extension:
#   dist/send-to-stash-video-chrome-<v>.zip    Chrome Web Store (also fine for Edge Add-ons)
#   dist/send-to-stash-video-firefox-<v>.zip   addons.mozilla.org (listed or self-distributed)
#   dist/store-assets/*.png                     screenshot and promo tiles the stores ask for
# Each zip gets a manifest trimmed to what that browser understands, so neither store flags warnings.
set -euo pipefail
cd "$(dirname "$0")"
VERSION=$(python3 -c 'import json;print(json.load(open("manifest.json"))["version"])')
python3 -c 'import shutil; shutil.rmtree("dist", ignore_errors=True)'
mkdir -p dist/chrome dist/firefox dist/store-assets
for b in chrome firefox; do cp background.js dist/$b/ && cp -R icons dist/$b/icons; done
python3 - <<'PY'
import json
m=json.load(open('manifest.json'))
c=json.loads(json.dumps(m)); c['background'].pop('scripts',None); c.pop('browser_specific_settings',None)
f=json.loads(json.dumps(m)); f['background'].pop('service_worker',None)
json.dump(c,open('dist/chrome/manifest.json','w'),indent=2); json.dump(f,open('dist/firefox/manifest.json','w'),indent=2)
PY
for b in chrome firefox; do (cd dist/$b && zip -qrX "../send-to-stash-video-$b-$VERSION.zip" . -x '.DS_Store'); done
python3 make-store-assets.py dist/store-assets
ls -l dist/*.zip dist/store-assets
