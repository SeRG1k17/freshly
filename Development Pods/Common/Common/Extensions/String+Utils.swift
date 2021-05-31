//
//  String+Utils.swift
//  Common
//
//  Created by Sergey Pugach on 11.05.21.
//

import UIKit


extension String {

    static let unknown = "unknown"
    
    var fromBase64: String? {
        
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    var toBase64: String {
        return Data(self.utf8).base64EncodedString()
    }
    
    public var capitalizedFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    
    func height(with width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [ .font: font ],
            context: nil
        )

        return ceil(boundingBox.height)
    }

    func width(with height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [ .font: font ],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}
