//
//  EventsUITests.swift
//  UITests
//
//  Created by Sergey Pugach on 24.05.21.
//

import XCTest
import Common

class EventsUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        app.launchArguments.append(LaunchArgument.testing.rawValue)
    }
    
    func testUpdateEvents() {
        app.launch()
        
        let tableView = app.tables.matching(identifier: Identifier.Events.table.rawValue).firstMatch
        waitForElementToAppear(tableView)
        
        let firstCell = tableView.cells.firstMatch
        
        let title = firstCell.children(matching: .staticText)[Identifier.Events.Table.Cell.title.rawValue]
        let date = firstCell.children(matching: .staticText)[Identifier.Events.Table.Cell.date.rawValue]
        let favourite = firstCell.children(matching: .button)[Identifier.Events.Table.Cell.favourite.rawValue]
        
        waitForElementToAppear(title)
        waitForElementToAppear(date)
        waitForElementToAppear(favourite)
    }
    
    func testSwitchTabToFavourites() {
        app.launch()
        
        app.tabBars.buttons[Identifier.Tab.favourites.rawValue].tap()
        
        let table = app.tables.matching(identifier: Identifier.Favourites.table.rawValue).firstMatch
        waitForElementToAppear(table)
    }
}
