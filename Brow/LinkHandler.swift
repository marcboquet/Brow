//
//  LinkHandler.swift
//  Brow
//
//  Created by Marc Boquet on 16/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import Cocoa

struct UrlAndBundleId {
    let url : String
    let bundleId : String
}

class LinkHandler {
    static let shared = LinkHandler()

    let linkOpener : LinkOpener
    let browserManager : BrowserManager

    init(linkOpener: LinkOpener = LinkOpener(), browserManager : BrowserManager = BrowserManager()) {
        self.linkOpener = linkOpener
        self.browserManager = browserManager
        registerAppleEvent()
    }
    
    @objc func handleURLEvent(_ event: NSAppleEventDescriptor,
                              withReplyEvent replyEvent: NSAppleEventDescriptor) {
        guard let urlString: String = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue else {
            return
        }
        handle(url: urlString)
    }
    
    
    func handle(url: String) {
        debugPrint("Handling \(url)")
        let bundleId = browserManager.bundleIdForUrl(url)
        
        if !linkOpener.open(UrlAndBundleId(url: url, bundleId: bundleId)) {
            linkOpener.open(UrlAndBundleId(url: url, bundleId: browserManager.defaultBundleId))
        }
    }
    
    private func registerAppleEvent() {
        NSAppleEventManager.shared().setEventHandler(
            self,
            andSelector: #selector(self.handleURLEvent(_:withReplyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
}
