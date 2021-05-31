//
//  UIViewController+Utls.swift
//  Common
//
//  Created by Sergey Pugach on 18.05.21.
//

import UIKit

public extension UIViewController {
    
    func addChild(_ viewController: UIViewController, to view: UIView, layout: (UIView) -> ()) {
        guard let childView = viewController.view else { return }
        
        addChild(viewController)
        view.addSubview(childView)
        viewController.didMove(toParent: self)
        layout(childView)
    }
}
