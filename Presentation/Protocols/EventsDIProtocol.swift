//
//  EventsDIProtocol.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import Foundation
import Domain

public protocol EventsDIProtocol {
    var eventsUseCase: EventsUseCaseProtocol { get }
    var favouritesUseCase: FavouritesUseCaseProtocol { get }
    var toggleUseCase: ToggleUseCaseProtocol { get }
}
