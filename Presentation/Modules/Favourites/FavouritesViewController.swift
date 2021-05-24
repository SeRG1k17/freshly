//
//  FavouritesViewController.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import UIKit
import RxSwift
import Domain
import RxRelay
import Common

public class FavouritesViewController: UIViewController, BindableType {

    @IBOutlet private weak var tableView: UITableView!
    
    public typealias ViewModel = FavouritesViewModelType
    
    private lazy var tableManager = EventsTableManager(with: tableView)
    private let disposeBag = DisposeBag()
    
    public let viewModel: ViewModel
    
    public init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind(to: viewModel)
    }
}


// MARK: - Bindings

extension FavouritesViewController {
    
    public func bind(to viewModel: ViewModel) {
        
        tableManager.selectedItem
            .subscribe(viewModel.input.selectedEvent)
            .disposed(by: disposeBag)
        
        tableManager.favouriteToggle
            .subscribe(viewModel.input.favouriteToggle)
            .disposed(by: disposeBag)
        
        viewModel.output.events
            .drive(tableManager.cellData)
            .disposed(by: disposeBag)
    }
}

private extension FavouritesViewController {
    
    func configureUI() {
        tableView.accessibilityLabel = Identifier.Favourites.table.rawValue
    }
}

