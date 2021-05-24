//
//  EventsViewController.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import UIKit
import RxSwift
import Domain
import RxRelay
import RxCocoa

public class EventsViewController: UIViewController, BindableType {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    public typealias ViewModel = EventsViewModelType
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var tableManager = EventsTableManager(with: tableView)
    private let updateRelay = PublishRelay<Void>()
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateRelay.accept(())
    }
}


// MARK: - Bindings

extension EventsViewController {
    
    public func bind(to viewModel: ViewModel) {
        
        updateRelay
            .subscribe(viewModel.input.update)
            .disposed(by: disposeBag)
        
        tableManager.selectedItem
            .subscribe(viewModel.input.selectedEvent)
            .disposed(by: disposeBag)
        
        tableManager.favouriteToggle
            .subscribe(viewModel.input.favouriteToggle)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(viewModel.input.refresh)
            .disposed(by: disposeBag)
        
        viewModel.output.eventsState
            .drive(onNext: { [weak self] (state: EventsState) in
                self?.configure(for: state)
            })
            .disposed(by: disposeBag)
    }
}

private extension EventsViewController {
    
    func configureUI() {
        activityIndicator.style = .large
        activityIndicator.color = .appGreen
        activityIndicator.hidesWhenStopped = true
        
        tableView.refreshControl = refreshControl
        refreshControl.tintColor = .appGreen
    }
    
    func configure(for state: EventsState) {
        switch state {
        
        case .loading:
            tableManager.cellData.onNext([])
            fallthrough
            
        case .updating:
            activityIndicator.startAnimating()
            refreshControl.endRefreshing()
            
        case .refreshing:
            activityIndicator.stopAnimating()
            refreshControl.beginRefreshing()
            
        case .idle(let events):
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
            tableManager.cellData.onNext(events)
        }
    }
}
