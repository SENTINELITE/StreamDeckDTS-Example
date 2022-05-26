
/*
 
 A bare-bones example of a StreamDeck Plugin using Emory Dunn's library, located here: https://github.com/emorydunn/StreamDeckPlugin
 
 This problem still occurs if we use an alternative library, located here: https://github.com/iKenndac/xcode-streamdeck-plugin
 
 More background on the expected behavior & other steps I tried are provided at this swift forum post: https://forums.swift.org/t/process-run-fails-to-actually-execute-until-parent-process-terminates/54627
 
 
 
 In order to correctly test this, you'll need Elgato's StreamDeck software installed on the device. There's a mobile app with a free 1 week trial, which can be used to debug this.
 
 Setup Instructions:
 • Mac StreamDeck Software: https://edge.elgato.com/egc/macos/sd/Stream_Deck_5.2.1.15025.pkg  Alt Link: https://www.elgato.com/en/downloads
 • iOS/iPadOS App Store Link: https://apps.apple.com/us/app/elgato-stream-deck-mobile/id1440014184
 • After building this package, under the derived data folder, run the following command to generate the StreamDeck Plugin's folder structure
 • Download the example shortcut (it's hardcoded, but you may change it) located here: https://www.icloud.com/shortcuts/7b67ea37a8c64e4bad7824925cdc41bd
 
 "~/Library/Developer/Xcode/DerivedData/StreamDeckDTS-Example-dystobzosnjkupdbeinrveevbdtg/Build/Products/Debug/shortcut-plugin" export --copy-executable --generate-manifest com.sentinelite.shortcutsDTS.sdPlugin
 
 After installing it all, quit & restart the StreamDeck Software, to boot up our new plugin.
 
 Open the Console.app & search for the process: `shortcut-plugin`, monitor the logs & push one of the key's to see the error...
 
 */


import Foundation
import StreamDeck

class ShortcutAction: Action {
    
    static var name: String = "Shortcut"
    
    static var uuid: String = "shortcut.run"
    
    static var icon: String = "Icons/actionIcon"
    
    static var states: [PluginActionState]? = [
        PluginActionState(image: "Icons/actionDefaultImage", titleAlignment: .middle)
    ]
    
    static var propertyInspectorPath: String?
    
    static var supportedInMultiActions: Bool?
    
    static var tooltip: String?
    
    static var visibleInActionsList: Bool?
    
    var context: String
    
    var coordinates: Coordinates
    
    @Environment(PluginCount.self) var count: Int
    
    required init(context: String, coordinates: Coordinates) {
        self.context = context
        self.coordinates = coordinates
    }
    
    //MARK: Where we respond to user clicks & execute the Shortcut functions.
    func keyDown(device: String, payload: KeyEvent) {
        let listOfAllShortcuts = shortcutFunc(args: ["list"]).split(whereSeparator: \.isNewline).map(String.init) //Creates an array of all the user's shortcuts, returned from the Shortcuts CLI
        let listOfFolders = shortcutFunc(args: ["list", "--folders"]).split(whereSeparator: \.isNewline).map(String.init) //Creates an array of folders, returned from the Shortcuts CLI
        
        
        NSLog("✅ \(listOfFolders)")
        NSLog("✅ \(listOfAllShortcuts)")
        
        NSLog("🏃 Shortcut Should Run here...")
        runShortcut(inputShortcut: "Apple-DTS-StreamDeck-Shortcut-Example") //The Hard-coded name of the shortcut. Example shortcut located here: https://www.icloud.com/shortcuts/7b67ea37a8c64e4bad7824925cdc41bd
        NSLog("❌ -> Launched Shortcut... Won't actually launch until StreamDeck Software Close???, run Output: ")
    }
    
    //MARK: This is where the Shortcuts CLI Fails to run a shortcut, until the parent process (The StreamDeck Software) exits.
    func runShortcut(inputShortcut: String) {
        let shortcutsCLI = Process()
        
        shortcutsCLI.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
        shortcutsCLI.arguments = ["run", "\(inputShortcut)"]
        shortcutsCLI.launch()
        
        // Waiting until the exit, will just freeze the rest of the process...
        //        shortcutsCLI.waitUntilExit()
    }
    
    //MARK: This shows that fetching folders & shortcuts from the Shortcuts CLI works...
    //You can optionally run a shortcut with the coorect arguments, but this has the same issue as the runShortcut function. Waiting will freeze the process!
    func shortcutFunc(args: [String]) -> String {
        NSLog("Running shortcutFunc with these Args: \(args)")
        let shortcutsCLI = Process()
        let pipe = Pipe()
        shortcutsCLI.standardOutput = pipe
        shortcutsCLI.standardError = pipe
        
        shortcutsCLI.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
        shortcutsCLI.arguments = args
        shortcutsCLI.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        guard let safeOutput = output else {
            return "nil"
        }
        
        shortcutsCLI.waitUntilExit()
        
        return safeOutput
    }
    
}
