//
//  NSPredicate+Helpers.swift
//  UITests
//
//  Created by Sergey Pugach on 24.05.21.
//

import Foundation

extension NSPredicate {
    convenience init(hittable: Bool) {
        self.init(format: "hittable == %@", NSNumber(value: hittable))
    }
    convenience init(exists: Bool) {
        self.init(format: "exists == %@", NSNumber(value: exists))
    }
}
