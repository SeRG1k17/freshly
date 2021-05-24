//
//  UIView+Utils.swift
//  Common
//
//  Created by Sergey Pugach on 18.05.21.
//

import UIKit

public extension UIView {
    
    func fillSuperviewWithLayout(inset: CGFloat, useSafeArea: Bool = false) {
        let insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        fillSuperviewWithLayout(insets: insets)
    }
    
    func fillSuperviewWithLayout(insets: UIEdgeInsets = .zero, useSafeArea: Bool = false) {
        guard let superview = superview else {
            return
        }
        
        fillWithLayout(superview, insets: insets, useSafeArea: useSafeArea)
    }
    
    func fillWithLayout(_ view: UIView, insets: UIEdgeInsets = .zero, useSafeArea: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
    
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right).isActive = true
        topAnchor.constraint(equalTo: useSafeArea
            ? view.safeAreaLayoutGuide.topAnchor
            : view.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
    }
}
