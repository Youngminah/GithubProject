//
//  GithubReposUITests.swift
//  GithubReposUITests
//
//  Created by meng on 2022/03/11.
//

import XCTest

class GithubReposUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testSearchRepositoryFlow() throws {
        let app = XCUIApplication()
        app.launch()
        let searchField = app.otherElements["searchBar"]
        searchField.tap()
        searchField.typeText("Youngminah")
        app.buttons["searchButton"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
