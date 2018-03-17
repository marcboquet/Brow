//
//  BrowserManagerTests.swift
//  BrowTests
//
//  Created by Marc Boquet on 17/03/2018.
//  Copyright © 2018 Marc Boquet. All rights reserved.
//

import XCTest
@testable import Brow

class BrowserManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testZoomUrl() {
        let url = "https://zoom.us/j/5556098446"
        let manager = BrowserManager()
        
        let result = manager.urlAndBundleIdForUrl(url)
        
        XCTAssertEqual(result.url, "zoommtg://zoom.us/join?action=join&confno=5556098446")
        XCTAssertEqual(result.bundleId, "us.zoom.xos")
    }

}
