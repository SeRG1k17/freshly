//
//  XCTestCase+Helpers.swift
//  UITests
//
//  Created by Sergey Pugach on 24.05.21.
//

import Foundation
import XCTest

extension XCTestCase {
    
    func waitForElementToAppear(_ element: XCUIElement, withPredicate customPredicate: NSPredicate? = nil, file: String = #file, line: Int = #line, waitTime: Double = 5.0) {
        waitForElement(element, predicates: NSPredicate(hittable: true), customPredicate, fileName: file, lineNumber: line, timeout: waitTime)
    }
    
    func waitForElementToExist(_ element: XCUIElement, withPredicate customPredicate: NSPredicate? = nil, file: String = #file, line: Int = #line, waitTime: Double = 10.0) {
        waitForElement(element, predicates: NSPredicate(exists: true), customPredicate, fileName: file, lineNumber: line, timeout: waitTime)
    }
    
    private func waitForElement(_ element: XCUIElement, predicates: NSPredicate?..., fileName: String, lineNumber: Int, timeout: Double = 10.0) {
        print("Started waiting for \(element).")
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates.compactMap { $0 })
        expectation(for: predicate, evaluatedWith: element, handler: nil)
        
        let message = "Failed to find \(element) after \(timeout) seconds."
        waitForExpectations(timeout: timeout) { (error) in
            if error != nil {
                
                let location = XCTSourceCodeLocation(filePath: fileName, lineNumber: lineNumber)
                let context = XCTSourceCodeContext(location: location)
                let issue = XCTIssue(
                    type: .assertionFailure,
                    compactDescription: message,
                    detailedDescription: nil,
                    sourceCodeContext: context,
                    associatedError: nil,
                    attachments: []
                )
                
                self.record(issue)
            }
        }
    }
}
