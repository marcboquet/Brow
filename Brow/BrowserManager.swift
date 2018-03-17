//
//  BrowserManager.swift
//  Brow
//
//  Created by Marc Boquet on 17/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import Foundation

class BrowserManager {
    var availableBrowsers : Set<String> = ["com.apple.Safari",
                                           "com.google.Chrome",
                                           "org.mozilla.firefox",
                                           "org.mozilla.firefoxdeveloperedition"]
    var lastBrowserUsed : String?
    var defaultBundleId = "com.apple.Safari"
    let appEventsHandler : SystemAppEventsHandler
    
    init(appEventsHandler : SystemAppEventsHandler = SystemAppEventsHandler.shared) {
        self.appEventsHandler = appEventsHandler
        configureEventsHandler()
    }

    func urlAndBundleIdForUrl(_ url: String) -> UrlAndBundleId {
        if url.starts(with: "https://zoom.us/j/") {
            if let meetingId = url.split(separator: "/").last {
                let zoomurl = "zoommtg://zoom.us/join?action=join&confno=\(meetingId)"
                return UrlAndBundleId(url: zoomurl, bundleId: "us.zoom.xos")
            }
        }
        if let lastBrowserUsed = lastBrowserUsed {
            return UrlAndBundleId(url: url, bundleId: lastBrowserUsed)
        }
        return UrlAndBundleId(url: url, bundleId: defaultBundleId)
    }
    
    private func configureEventsHandler() {
        frontmostAppDidChange(appEventsHandler.frontmostApp)
        runningAppsDidChange(appEventsHandler.runningApps)
        appEventsHandler.onRunningAppsChange = { runningApps in
            self.runningAppsDidChange(runningApps)
        }
        appEventsHandler.onFrontmostAppChange = { frontmostApp in
            self.frontmostAppDidChange(frontmostApp)
        }
    }
    
    private func frontmostAppDidChange(_ frontmostApp: String) {
        if availableBrowsers.contains(frontmostApp) {
            lastBrowserUsed = frontmostApp
        }
    }
    
    private func runningAppsDidChange(_ runningApps: Set<String>) {
        
    }
}
