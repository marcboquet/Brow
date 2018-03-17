//
//  AppDelegate.swift
//  Brow
//
//  Created by Marc Boquet on 14/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import Cocoa
import CoreServices

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let appEventsHandler = SystemAppEventsHandler.shared
    let linkHandler = LinkHandler.shared
    let menu = Menu()

    func applicationWillFinishLaunching(_ notification: Notification) {
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu.createStatusItem()
        appEventsHandler.setAsDefault()
    }
}

