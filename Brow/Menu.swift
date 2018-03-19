//
//  Menu.swift
//  Brow
//
//  Created by Marc Boquet on 16/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import Cocoa

class Menu {
    var statusItem: NSStatusItem!
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(lastBrowserUsedChanged), name: NSNotification.Name("lastBrowserUsedChanged"), object: nil)
    }

    func createStatusItem() {
        if statusItem != nil { return }
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.toolTip = "Brow"
        statusItem.highlightMode = true
        setImage("com.apple.Safari")
        statusItem.menu = createMenu()
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu(title: "Brow")
        let menuItem = NSMenuItem(title: "Quit", action: #selector(doQuit), keyEquivalent: "q")
        menuItem.target = self
        menu.addItem(menuItem)
        return menu
    }
    
    func setImage(_ bundleId : String) {
        if let button = statusItem?.button {
            var image = NSImage(named: NSImage.Name(bundleId))
            if image == nil {
                image = NSImage(named: NSImage.Name("com.apple.Safari"))
            }
            image?.isTemplate = true
            button.image = image
        }
    }
    
    @objc func doQuit() {
        NSApp.terminate(nil)
    }
    
    @objc func lastBrowserUsedChanged(notification: NSNotification) {
        if let bundleId : String = notification.object as? String {
            setImage(bundleId)
        }
    }
}
