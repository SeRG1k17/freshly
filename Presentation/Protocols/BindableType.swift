//
//  BindableType.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import UIKit

public protocol BindableType {
    
    associatedtype ViewModel
    var viewModel: ViewModel { get }
    
    func bind(to viewModel: ViewModel)
}
