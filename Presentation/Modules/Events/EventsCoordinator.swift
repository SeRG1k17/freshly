//
//  EventsCoordinator.swift
//  Presentation
//
//  Created by Sergey Pugach on 18.05.21.
//

import Common
import XCoordinator
import RxSwift
import Domain

public enum EventsRoute: Route {
    case url(URL)
}

public class EventsCoordinator: ViewCoordinator<EventsRoute> {
    
    public struct Dependencies {
        let eventsUseCase: EventsUseCaseProtocol
        let toggleUseCase: ToggleUseCaseProtocol
        public init(eventsUseCase: EventsUseCaseProtocol, toggleUseCase: ToggleUseCaseProtocol) {
            self.eventsUseCase = eventsUseCase
            self.toggleUseCase = toggleUseCase
        }
    }
    
    private let triggerSubject = PublishSubject<EventsRoute>()
    private let rootVC = UIViewController()
    
    private let dependencies: Dependencies
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        super.init(rootViewController: rootVC)
        
        let events = Module(
            viewModel: EventsViewModel(
                dependencies: .init(
                    eventsUseCase: dependencies.eventsUseCase,
                    toggleUseCase: dependencies.toggleUseCase
                ),
                coordinator: self
            ),
            viewController: { EventsViewController(with: $0) }
        )
        
        rootVC.addChild(events.viewController, to: rootVC.view, layout: {
            $0.fillSuperviewWithLayout()
        })
    }
    
    public override func prepareTransition(for route: EventsRoute) -> ViewTransition {
        triggerSubject.onNext(route)
        
        switch route {
        case .url(_):
            return .none()
        }
    }
}

extension EventsCoordinator {
    public var triggered: Observable<EventsRoute> {
        triggerSubject
    }
}
