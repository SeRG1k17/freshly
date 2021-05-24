//
//  BaseTableManager.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import UIKit.UITableView
import RxSwift
import RxRelay
import Instance

class BaseTableManager: NSObject {

    weak var tableView: UITableView! {
        didSet { setupTableView(tableView) }
    }

    init(with tableView: UITableView) {
        defer { self.tableView = tableView }

        super.init()
    }

    func setupTableView(_ tableView: UITableView) {

        register(for: tableView)
    }

    func register(for tableView: UITableView) {}
}
