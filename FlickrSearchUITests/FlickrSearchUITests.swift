//
//  FlickrSearchUITests.swift
//  FlickrSearchUITests
//
//  Created by Barnabás Kun on 2025. 08. 15..
//

import XCTest

final class FlickrSearchUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        
        app.launchArguments += ["-UITesting"]
        app.launch()
    }

    @MainActor
    func testSearchFlow_WhenTypingAndSearching_ShouldDisplayResults() {
        let searchField = app.textFields["Search photos..."]
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("Cats")
        app.buttons["Search"].tap()
        
        let firstImage = app.images.firstMatch
        XCTAssertTrue(firstImage.waitForExistence(timeout: 5))
    }
}
