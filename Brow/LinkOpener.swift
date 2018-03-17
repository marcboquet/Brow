//
//  LinkOpener.swift
//  Brow
//
//  Created by Marc Boquet on 17/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import Cocoa

class LinkOpener {
    let workspace : NSWorkspace
    
    init(workspace: NSWorkspace = NSWorkspace.shared) {
        self.workspace = workspace
    }
    
    @discardableResult
    func open(_ urlAndBundle: UrlAndBundleId) -> Bool {
        guard let url: URL = URL(string: urlAndBundle.url) else {
            return false
        }
        
        return workspace.open(
            [url],
            withAppBundleIdentifier: urlAndBundle.bundleId,
            options: NSWorkspace.LaunchOptions.default,
            additionalEventParamDescriptor: nil,
            launchIdentifiers: nil
        )
    }
}
