//
//  FavouritesViewModel.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import RxSwift
import RxCocoa
import Domain

public protocol FavouritesViewModelInput {
    var selectedEvent: AnyObserver<Domain.Event> { get }
    var favouriteToggle: AnyObserver<Domain.Event> { get }
}

public protocol FavouritesViewModelOutput {
    var events: Driver<[Domain.Event]> { get }
}

public protocol FavouritesViewModelType {
    var input: FavouritesViewModelInput { get }
    var output: FavouritesViewModelOutput { get }
}

public final class FavouritesViewModel: FavouritesViewModelType {
    
    public struct Dependencies {
        let favouritesUseCase: FavouritesUseCaseProtocol
        let toggleUseCase: ToggleUseCaseProtocol
    }
    
    private let selectedEvent = PublishSubject<Domain.Event>()
    private let favouriteToggle = PublishSubject<Domain.Event>()
    private let disposeBag = DisposeBag()
    
    private let dependencies: Dependencies
    private let coordinator: FavouritesCoordinator
    public init(dependencies: Dependencies, coordinator: FavouritesCoordinator) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        
        registerObserver()
    }
    
    public private(set) lazy var input: FavouritesViewModelInput = Input(
        selectedEvent: selectedEvent.asObserver(),
        favouriteToggle: favouriteToggle.asObserver()
    )
    public private(set) lazy var output: FavouritesViewModelOutput = Output(
        events: dependencies.favouritesUseCase.events
            .asDriver(onErrorJustReturn: [])
    )
}

// MARK: - FavouritesViewModelType

extension FavouritesViewModel {
    struct Input: FavouritesViewModelInput {
        let selectedEvent: AnyObserver<Domain.Event>
        let favouriteToggle: AnyObserver<Domain.Event>
    }
    struct Output: FavouritesViewModelOutput {
        let events: Driver<[Domain.Event]>
    }
}

private extension FavouritesViewModel {
    
    func registerObserver() {
        
        selectedEvent
            .flatMap({ [unowned self] (event: Domain.Event) in
                coordinator.rx.trigger(.url(event.url))
                    .catchErrorJustReturn(())
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        favouriteToggle
            .flatMap({ [unowned self] (event: Domain.Event) -> Completable in
                dependencies.toggleUseCase.toggle(event)
                    .catchError({ _ in Completable.empty() })
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}

