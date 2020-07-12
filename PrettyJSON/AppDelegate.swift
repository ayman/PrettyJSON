//
//  AppDelegate.swift
//  PrettyJSON
//
//  Created by David A Shamma on 12/10/18.
//  Copyright © 2018 shaumur.ai. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var openMenuItem: NSMenuItem!
    @IBOutlet weak var closeMenuItem: NSMenuItem!
    @IBOutlet weak var mainWindowMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
