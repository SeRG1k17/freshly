//
//  EventTableViewCell.swift
//  Presentation
//
//  Created by Sergey Pugach on 18.05.21.
//

import UIKit
import Domain
import RxCocoa
import RxSwift
import Common

class EventTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureUI()
    }
    
    var favouriteToggle: Observable<Void> {
        return favouriteButton.rx.tap.asObservable()
    }
}

extension EventTableViewCell {
    
    func configure(by item: Domain.Event) {
        titleLabel.text = item.title
        dateLabel.text = DateFormatter.event.string(from: item.date)
        favouriteButton.setImage(item.favImage, for: .normal)
    }
}

private extension EventTableViewCell {
    
    func configureUI() {
        titleLabel.font = .systemFont(ofSize: 15.0, weight: .medium)
        dateLabel.font = .systemFont(ofSize: 10.0, weight: .regular)
        
        titleLabel.textColor = .appGreen
        dateLabel.textColor = .appGreen
        favouriteButton.tintColor = .appGreen
        favouriteButton.setTitle(nil, for: .normal)
        
        titleLabel.accessibilityLabel = Identifier.Events.Table.Cell.title.rawValue
        dateLabel.accessibilityLabel = Identifier.Events.Table.Cell.date.rawValue
        favouriteButton.accessibilityLabel = Identifier.Events.Table.Cell.favourite.rawValue
    }
}

private extension DateFormatter {
    static let event: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy hh:mm"
        return formatter
    }()
}

private extension Domain.Event {
    var favImage: UIImage? {
        return UIImage.init(systemName: isFavourite ? "star.fill" : "star")
    }
}
