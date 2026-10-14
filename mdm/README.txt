Stash Video MDM profile

StashVideo-BackgroundItems.mobileconfig pre-approves the Stash Video Updater daemon
on macOS 13 and later through a Service Management (com.apple.servicemanagement)
payload. Its single rule matches the launchd label com.ayala.solutions.stashvideo.updater,
so it covers only the updater and nothing else signed by the same team.

Import the file into your MDM as-is and scope it to the Stash Video Macs at the device
level. With the profile installed, Settings > Updates > Set Up Self-Service Updates
completes without an administrator, and Install Update appears for every account.

The updater installs nothing except signed, notarized Stash Video releases downloaded
from the public release page; the app only ever sends it a version number.
