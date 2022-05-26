# StreamDeckDTS-Example
Apple DTS support repo.

A detailed example of the issue is located on [this](https://forums.swift.org/t/process-run-fails-to-actually-execute-until-parent-process-terminates/54627) Swift forum post.

Feedback Number: FB9865328 • Execute Shortcut with the Shortcuts CLI via the Shortcut's UUID

🎥 [Video overview of the bug.](https://share.cleanshot.com/R9TLzE)

---

 In order to correctly test this, you'll need Elgato's StreamDeck software installed on the device. There's a mobile app with a free 1 week trial, which can be used to debug this.
 
 Setup Instructions:
 • Download this project, & build it.
 • Mac StreamDeck Software: https://edge.elgato.com/egc/macos/sd/Stream_Deck_5.2.1.15025.pkg  Alt Link: https://www.elgato.com/en/downloads
 • iOS/iPadOS App Store Link: https://apps.apple.com/us/app/elgato-stream-deck-mobile/id1440014184
 • After building this package, under the derived data folder, run the following command to generate the StreamDeck Plugin's folder structure
 • Download the example shortcut (it's hardcoded, but you may change it) located here: https://www.icloud.com/shortcuts/7b67ea37a8c64e4bad7824925cdc41bd
 
 `"~/Library/Developer/Xcode/DerivedData/StreamDeckDTS-Example-dystobzosnjkupdbeinrveevbdtg/Build/Products/Debug/shortcut-plugin" export --copy-executable --generate-manifest com.sentinelite.shortcutsDTS.sdPlugin`
 
 After installing it all, quit & restart the StreamDeck Software, to boot up our new plugin.
 
 Open the Console.app & search for the process: `shortcut-plugin`, monitor the logs & push one of the key's to see the error...