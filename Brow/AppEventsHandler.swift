//
//  CurrentApps.swift
//  Brow
//
//  Created by Marc Boquet on 16/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import Cocoa

class SystemAppEventsHandler {
    static let shared = SystemAppEventsHandler()
    
    var onFrontmostAppChange: ((_ result: String)->())?
    var onRunningAppsChange: ((_ result: Set<String>)->())?
    
    var frontmostApp : String = "" {
        didSet { onFrontmostAppChange?(frontmostApp) }
    }
    var runningApps : Set<String> = [] {
        didSet { onRunningAppsChange?(runningApps) }
    }
    
    init() {
        frontmostApp = fetchFrontmostApplication() ?? ""
        runningApps = fetchRunningApplications()
        configureObservation()
    }
    
    func installedBrowsers() -> [String] {
        guard let ids = LSCopyAllHandlersForURLScheme("https" as CFString)?.takeRetainedValue() as? [String] else {
            return []
        }
        return ids
    }
    
    func urlForBundleIdentifier(_ bundleId: String) -> URL? {
        guard let result = LSCopyApplicationURLsForBundleIdentifier(bundleId as CFString, nil)?.takeUnretainedValue() as [AnyObject]?, let urls = result as? [URL] else {
            return nil
        }
        return urls.first
    }
    
    func frontmostApplicationDidChange() {
        frontmostApp = fetchFrontmostApplication() ?? ""
        debugPrint(frontmostApp)
    }
    
    func runningApplicationsDidChange() {
        runningApps = fetchRunningApplications()
        debugPrint("runningApps: \(runningApps.count)")
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
    
    private func fetchFrontmostApplication() -> String? {
        return NSWorkspace.shared.frontmostApplication?.bundleIdentifier
    }
    
    private func fetchRunningApplications() -> Set<String> {
        let apps = NSWorkspace.shared.runningApplications.flatMap { $0.bundleIdentifier }
        let set = Set(apps)
        return set
    }
    
    private var observationTokens: [NSKeyValueObservation] = []
    private func configureObservation() {
        var token = NSWorkspace.shared.observe(\.frontmostApplication, options: [.initial, .new]) { [weak self] _, _ in
            self?.frontmostApplicationDidChange()
        }
        observationTokens.append(token)
        token = NSWorkspace.shared.observe(\.runningApplications, options: [.initial, .new]) { [weak self] _, _ in
            self?.runningApplicationsDidChange()
        }
        observationTokens.append(token)
    }
}
