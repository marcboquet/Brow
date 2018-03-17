//
//  Menu.swift
//  Brow
//
//  Created by Marc Boquet on 16/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import Cocoa

class Menu {
    var statusItem: NSStatusItem?

    func createStatusItem() {
        if self.statusItem != nil { return }
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.toolTip = "Brow"
        statusItem.highlightMode = true
        statusItem.button?.image = #imageLiteral(resourceName: "FirefoxDeveloperEdition")
        statusItem.button?.image?.isTemplate = true
        statusItem.menu = createMenu()
        self.statusItem = statusItem
    }
    
    func createMenu() -> NSMenu {
        let menu = NSMenu(title: "Brow")
        let menuItem = NSMenuItem(title: "Quit", action: #selector(doQuit), keyEquivalent: "q")
        menuItem.target = self
        menu.addItem(menuItem)
        return menu
    }
    
    @objc func doQuit() {
        NSApp.terminate(nil)
    }
}
