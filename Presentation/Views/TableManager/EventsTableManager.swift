//
//  EventsTableManager.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import UIKit
import RxSwift
import RxRelay
import Domain

class EventsTableManager: BaseTableManager {
    
    typealias SectionType = Int
    typealias ItemType = Domain.Event
    typealias CellType = EventTableViewCell

    let favouriteToggle = PublishRelay<ItemType>()
    let selectedItem = PublishRelay<ItemType>()
    let cellData = PublishSubject<[ItemType]>()
    
    private(set) lazy var dataSource: SectionedDataSource = {
        return SectionedDataSource(configureCell: { [weak self] _, tableView, indexPath, item -> UITableViewCell in

            guard let self = self else { return CellType() }
            return self.dequeue(for: tableView, at: indexPath, with: item)
        })
    }()
    
    private let disposeBag = DisposeBag()

    override func setupTableView(_ tableView: UITableView) {
        super.setupTableView(tableView)
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        
        register(for: tableView)
        registerObservers()
    }

    override func register(for tableView: UITableView) {
        super.register(for: tableView)
        
        CellType.registerNib(for: tableView, bundle: .module)
    }
}

extension EventsTableManager: SectionedDataSourceAnimatable {
    
    func configure(_ cell: EventTableViewCell, at indexPath: IndexPath, with item: ItemType) {
        cell.configure(by: item)
        
        cell.favouriteToggle
            .map({ _ -> ItemType in item })
            .subscribe(onNext: { [weak self] (event: ItemType) in
                self?.favouriteToggle.accept(event)
            })
            .disposed(by: cell.disposeBag)
    }
}

private extension EventsTableManager {
    
    func registerObservers() {
        
        cellData
            .map({ (events: [ItemType]) -> [Model] in
                [Model(model: 0, items: events)]
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .do(onNext: { [weak self] (indexPath: IndexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .map({ [unowned self] (indexPath: IndexPath) -> ItemType in
                return self.dataSource.sectionModels[indexPath.section].items[indexPath.row]
            })
            .bind(to: selectedItem)
            .disposed(by: disposeBag)
    }
}
