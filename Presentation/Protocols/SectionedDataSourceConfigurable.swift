//
//  SectionedDataSourceConfigurable.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import RxDataSources
import Instance

protocol SectionedDataSourceConfigurable {

    associatedtype ItemType
    associatedtype SectionType

    associatedtype CellType: UITableViewCell

    func dequeue(for tableView: UITableView, at indexPath: IndexPath, with item: ItemType) -> UITableViewCell
    func configure(_ cell: CellType, at indexPath: IndexPath, with item: ItemType)
}

extension SectionedDataSourceConfigurable {

    func dequeue(for tableView: UITableView, at indexPath: IndexPath, with item: ItemType) -> UITableViewCell {

        let cell = CellType.dequeue(from: tableView, for: indexPath)
        configure(cell, at: indexPath, with: item)

        return cell
    }

    func configure(_ cell: CellType, at indexPath: IndexPath, with item: ItemType) {}
}




protocol SectionedDataSourceAnimatable: SectionedDataSourceConfigurable where
    ItemType: IdentifiableType,
    ItemType: Equatable,
SectionType: IdentifiableType {
    
    typealias Model = AnimatableSectionModel<SectionType, ItemType>
    typealias SectionedDataSource = RxTableViewSectionedAnimatedDataSource<Model>
    
    var dataSource: SectionedDataSource { get }
    func configure(_ dataSource: SectionedDataSource)
}

extension SectionedDataSourceAnimatable {
    func configure(_ dataSource: SectionedDataSource) {}
}

protocol SectionedDataSourceReloadable: SectionedDataSourceConfigurable {
    
    typealias Model = SectionModel<SectionType, ItemType>
    typealias SectionedDataSource = RxTableViewSectionedReloadDataSource<Model>
    
    var dataSource: SectionedDataSource { get }
    func configure(_ dataSource: SectionedDataSource)
}

extension SectionedDataSourceReloadable {
    func configure(_ dataSource: SectionedDataSource) {}
}
