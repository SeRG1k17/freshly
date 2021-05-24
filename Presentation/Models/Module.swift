//
//  Module.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import UIKit

public struct Module<ViewModel, ViewController> where ViewController: UIResponder {

    public let viewModel: ViewModel
    public let viewController: ViewController

    public init(viewModel: ViewModel, viewController: (ViewModel) -> (ViewController)) {
        self.viewModel = viewModel
        self.viewController = viewController(viewModel)
    }
}
