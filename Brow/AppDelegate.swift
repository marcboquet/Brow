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
    var statusItem: NSStatusItem?

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSAppleEventManager.shared().setEventHandler(self,
                                                     andSelector: #selector(self.handleURLEvent(_:withReplyEvent:)),
                                                     forEventClass: AEEventClass(kInternetEventClass),
                                                     andEventID: AEEventID(kAEGetURL))
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let browserURL = urlForBundleIdentifier("com.apple.safari") {
            print(browserURL)
        }
        let ids = bundleIdentifiers()
        print(ids)
        
        NSWorkspace.shared.addObserver(self, forKeyPath: "frontmostApplication", options: [.initial, .old, .new], context: nil)
        NSWorkspace.shared.addObserver(self, forKeyPath: "runningApplications", options: [.initial, .new], context: nil)
        
        setAsDefault()
        
        createStatusItem()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frontmostApplication" {
            if let bundleId = NSWorkspace.shared.frontmostApplication?.bundleIdentifier {
                print(bundleId)
            }
        } else if keyPath == "runningApplications" {
            print(NSWorkspace.shared.runningApplications.flatMap { $0.bundleIdentifier })
        }
    }
    
    func urlForBundleIdentifier(_ bundleId: String) -> URL? {
        guard let result = LSCopyApplicationURLsForBundleIdentifier(bundleId as CFString, nil)?.takeUnretainedValue() as [AnyObject]?, let urls = result as? [URL] else {
            return nil
        }
        return urls.first
    }
    
    func bundleIdentifiers() -> [String] {
        guard let ids = LSCopyAllHandlersForURLScheme("https" as CFString)?.takeRetainedValue() as? [String] else {
            return []
        }
        
        return ids
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        NSWorkspace.shared.removeObserver(self, forKeyPath: "frontmostApplication")
        NSWorkspace.shared.removeObserver(self, forKeyPath: "runningApplications")
    }
    
    func setAsDefault() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return
        }
        
        LSSetDefaultHandlerForURLScheme("http" as CFString, bundleIdentifier as CFString)
        LSSetDefaultHandlerForURLScheme("https" as CFString, bundleIdentifier as CFString)
        LSSetDefaultRoleHandlerForContentType(kUTTypeHTML, .viewer, bundleIdentifier as CFString)
        LSSetDefaultRoleHandlerForContentType(kUTTypeURL, .viewer, bundleIdentifier as CFString)
    }
    
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor,
                      withReplyEvent replyEvent: NSAppleEventDescriptor) {
        
        guard let urlString: String = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue else {
            return
        }
        
        handle(url: urlString)
    }
    
    let safariBundleId = "com.apple.Safari"
    func handle(url: String) {
        let bundleId = "com.google.Chrome"//bundle(for: url)
        
        if !open(url: url, bundleId: bundleId) {
            open(url: url, bundleId: safariBundleId)
        }
    }
    
    @discardableResult
    private func open(url: String, bundleId: String) -> Bool {
        guard let url: URL = URL(string: url) else {
            return false
        }
        
        return NSWorkspace.shared.open(
            [url],
            withAppBundleIdentifier: bundleId,
            options: NSWorkspace.LaunchOptions.default,
            additionalEventParamDescriptor: nil,
            launchIdentifiers: nil
        )
    }
    
    func createStatusItem() {
        guard statusItem == nil else {
            return
        }
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.toolTip = "Brow"
        statusItem?.highlightMode = true
        statusItem?.menu = createMenu()
    }
    func createMenu() -> NSMenu {
        let menu = NSMenu()
        let menuItem = NSMenuItem(title: "Quit", action: #selector(doQuit), keyEquivalent: "q")
        menu.addItem(menuItem)
        return menu
    }
    @objc func doQuit() {
        NSApp.terminate(nil)
    }
}

