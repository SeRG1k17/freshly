//
//  EventsDI.swift
//  Freshly
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation
import Domain
import Platform
import Presentation

class EventsDI: EventsDIProtocol {
    
    struct Dependencies {
        let networkService: NetworkServiceProtocol
        let storageService: StorageServiceProtocol
    }
    
    private lazy var eventsRepo = EventsRepository(
        dependencies: .init(
            networkService: dependencies.networkService,
            storageService: dependencies.storageService
        )
    )
    
    public private(set) lazy var eventsUseCase: EventsUseCaseProtocol = EventsUseCase(
        eventsRepository: eventsRepo
    )
    public private(set) lazy var favouritesUseCase: FavouritesUseCaseProtocol = FavouritesUseCase(
        eventsRepository: eventsRepo
    )
    public private(set) lazy var toggleUseCase: ToggleUseCaseProtocol = ToggleUseCase(
        eventsRepository: eventsRepo
    )
    
    private let appEnvironment: AppEnvironment
    private let dependencies: Dependencies
    
    init(appEnvironment: AppEnvironment, dependencies: Dependencies) {
        self.appEnvironment = appEnvironment
        self.dependencies = dependencies
    }
}
