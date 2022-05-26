//
//  CounterPlugin.swift
//  
//
//  Created by Emory Dunn on 10/12/21.
//

import Foundation
import StreamDeck

@main
class ShortcutPlugin: PluginDelegate {
    
    // MARK: Manifest
    static var name: String = "StreamDeck-DTS-Example"
    
    static var description: String = "Run a shortcut!"
    
    static var category: String? = "StreamDeck-DTS-Example"
    
    static var categoryIcon: String?
    
    static var author: String = "SENTINELITE"
    
    static var icon: String = "Icons/pluginIcon"
    
    static var url: URL? = URL(string: "https://github.com/emorydunn/StreamDeckPlugin")
    
    static var version: String = "1.0"
    
    static var os: [PluginOS] = [.mac(minimumVersion: "12.0")]
    
    static var applicationsToMonitor: ApplicationsToMonitor?
    
    static var software: PluginSoftware = .minimumVersion("5.0")
    
    static var sdkVersion: Int = 2
    
    static var codePath: String = ShortcutPlugin.executableName
    
    static var codePathMac: String?
    
    static var codePathWin: String?
    
    static var actions: [Action.Type] = [
        ShortcutAction.self
    ]
    
    @Environment(PluginCount.self) var count: Int
    
    required init() {
        NSLog("CounterPlugin init!, with count: \(count)")
        count = 10
    }
    
    // This should run a shortcut via the Shortcut CLI, but fails...
    func keyDown(action: String, context: String, device: String, payload: KeyEvent) {
        StreamDeckPlugin.shared.instances.values.forEach {
            $0.setTitle(to: "\(count)", target: nil, state: nil)
        }
        NSLog("❄️ State update: \(count) \n payload: \(payload), \n context \(context), \n Device: \(device), \n Action: \(action)")
        
    }
}
