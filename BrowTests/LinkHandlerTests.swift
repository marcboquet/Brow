//
//  BrowserManagerTests.swift
//  BrowTests
//
//  Created by Marc Boquet on 16/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import XCTest
@testable import Brow

class FakeLinkOpener : LinkOpener {
    var opened : [UrlAndBundleId] = []

    override func open(_ urlAndBundle: UrlAndBundleId) -> Bool {
        opened.append(urlAndBundle)
        return urlAndBundle.bundleId == "bad.bundle" ? false : true
    }
}

class FakeBrowserManager : BrowserManager {
    var theBundleId = "com.google.Chrome"

    override func bundleIdForUrl(_ url: String) -> String {
        return theBundleId
    }
}

class LinkHandlerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHandle() {
        let linkOpener = FakeLinkOpener()
        let browserManager = FakeBrowserManager()
        let handler = LinkHandler(linkOpener: linkOpener, browserManager: browserManager)
        
        handler.handle(url: "https://example.com")
        
        XCTAssertEqual(linkOpener.opened.count, 1)
        XCTAssertEqual(linkOpener.opened.first?.url, "https://example.com")
        XCTAssertEqual(linkOpener.opened.first?.bundleId, "com.google.Chrome")
    }
    
    func testHandleBadBundle() {
        let linkOpener = FakeLinkOpener()
        let browserManager = FakeBrowserManager()
        let handler = LinkHandler(linkOpener: linkOpener, browserManager: browserManager)
        
        browserManager.theBundleId = "bad.bundle"
        handler.handle(url: "https://example.com")
        
        XCTAssertEqual(linkOpener.opened.count, 2)
        XCTAssertEqual(linkOpener.opened.first?.bundleId, "bad.bundle")
        XCTAssertEqual(linkOpener.opened.last?.bundleId, "com.apple.Safari")
    }
}
