//
//  FavouritesCoordinator.swift
//  Presentation
//
//  Created by Sergey Pugach on 19.05.21.
//

import RxSwift
import Common
import XCoordinator
import Domain

public enum FavouritesRoute: Route {
    case url(URL)
}

public class FavouritesCoordinator: ViewCoordinator<FavouritesRoute> {
    
    public struct Dependencies {
        let favouritesUseCase: FavouritesUseCaseProtocol
        let toggleUseCase: ToggleUseCaseProtocol
        public init(favouritesUseCase: FavouritesUseCaseProtocol, toggleUseCase: ToggleUseCaseProtocol) {
            self.favouritesUseCase = favouritesUseCase
            self.toggleUseCase = toggleUseCase
        }
    }
    
    private let triggerSubject = PublishSubject<FavouritesRoute>()
    private let rootVC = UIViewController()
    
    private let dependencies: Dependencies
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        super.init(rootViewController: rootVC)
        //super.init(viewController: Favourites.viewController, parent: parent, map: nil)
        //favourites.viewModel.coordinator = self
        
        let favourites = Module(
            viewModel: FavouritesViewModel(
                dependencies: .init(
                    favouritesUseCase: dependencies.favouritesUseCase,
                    toggleUseCase: dependencies.toggleUseCase
                ),
                coordinator: self
            ),
            viewController: { FavouritesViewController(with: $0) }
        )
        
        rootVC.addChild(favourites.viewController, to: rootVC.view, layout: {
            $0.fillSuperviewWithLayout()
        })
    }
    
    public override func prepareTransition(for route: FavouritesRoute) -> ViewTransition {
        triggerSubject.onNext(route)
        
        switch route {
        case .url(_):
            return .none()
        }
    }
}

extension FavouritesCoordinator {
    public var triggered: Observable<FavouritesRoute> {
        triggerSubject
    }
}

