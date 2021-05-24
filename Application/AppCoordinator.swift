//
//  AppCoordinator.swift
//  Freshly
//
//  Created by Sergey Pugach on 12.05.21.
//

import RxSwift
import XCoordinator
import Presentation
import Common

class AppCoordinator: TabBarCoordinator<AppRoute> {

    private let appDI: AppDIProtocol
    private lazy var eventsCoordinator: EventsCoordinator = {
        let coordinator = EventsCoordinator(
            dependencies: EventsCoordinator.Dependencies(
                eventsUseCase: appDI.eventsDI.eventsUseCase,
                toggleUseCase: appDI.eventsDI.toggleUseCase
            )
        )
        
        let root = coordinator.rootViewController
        root.tabBarItem.image = UIImage(systemName: "note")
        root.tabBarItem.selectedImage = UIImage(systemName: "note.text")
        root.title = "Events"
        root.accessibilityLabel = Identifier.Tab.events.rawValue
        
        return coordinator
    }()
    
    private lazy var favouriteCoordinator: FavouritesCoordinator = {
        let coordinator = FavouritesCoordinator(
            dependencies: FavouritesCoordinator.Dependencies(
                favouritesUseCase: appDI.eventsDI.favouritesUseCase,
                toggleUseCase: appDI.eventsDI.toggleUseCase
            )
        )
        
        let root = coordinator.rootViewController
        root.tabBarItem.image = UIImage(systemName: "star")
        root.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        root.title = "Favourites"
        root.accessibilityLabel = Identifier.Tab.favourites.rawValue
        
        return coordinator
    }()
    
    private let disposeBag = DisposeBag()
    
    init(appDI: AppDIProtocol) {
        self.appDI = appDI
        
        super.init(initialRoute: .tabs)

        UITabBar.appearance().tintColor = .appGreen
        registerObservers()
    }

    override func prepareTransition(for route: AppRoute) -> TabBarTransition {
        switch route {
        case .events:
            return .select(eventsCoordinator)
        case .favourite:
            return .select(favouriteCoordinator)
        case .url(let url):
            return .present(urlModule(for: url).viewController)
        case .tabs:
            return .set([eventsCoordinator, favouriteCoordinator])
        }
    }
}

private extension AppCoordinator {
    
    func urlModule(for url: URL) -> Module<URLViewModelType, UIViewController> {
        return Module(
            viewModel: URLViewModel(url: url, coordinator: eventsCoordinator),
            viewController: { URLViewController(with: $0) }
        )
    }
    
    func registerObservers() {
        
        eventsCoordinator.triggered
            .map({ $0.appRoute })
            .compactMap({ $0 })
            .flatMap({
                self.rx.trigger($0)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}

private extension EventsRoute {
    var appRoute: AppRoute? {
        switch self {
        case .url(let url):
            return .url(url)
        }
    }
}
