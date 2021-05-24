//
//  EventsViewModel.swift
//  Presentation
//
//  Created by Sergey Pugach on 12.05.21.
//

import Domain
import RxCocoa
import RxSwift

public protocol EventsViewModelInput {
    var update: AnyObserver<Void> { get }
    var refresh: AnyObserver<Void> { get }
    var selectedEvent: AnyObserver<Domain.Event> { get }
    var favouriteToggle: AnyObserver<Domain.Event> { get }
}

public protocol EventsViewModelOutput {
    var eventsState: Driver<EventsState> { get }
}

public protocol EventsViewModelType {
    var input: EventsViewModelInput { get }
    var output: EventsViewModelOutput { get }
}

public enum EventsState: Equatable {
    case loading
    case refreshing
    case updating
    case idle([Domain.Event])
}

public final class EventsViewModel: EventsViewModelType {
    
    public struct Dependencies {
        let eventsUseCase: EventsUseCaseProtocol
        let toggleUseCase: ToggleUseCaseProtocol
    }
    
    private let dependencies: Dependencies
    private let coordinator: EventsCoordinator
    public init(dependencies: Dependencies, coordinator: EventsCoordinator) {
        self.dependencies = dependencies
        self.coordinator = coordinator
        registerObserver()
    }
    
    private let eventsStateSubject = PublishSubject<EventsState>()
    private let updateSubject = PublishSubject<Void>()
    private let refreshSubject = PublishSubject<Void>()
    private let selectedEvent = PublishSubject<Domain.Event>()
    private let favouriteToggle = PublishSubject<Domain.Event>()
    
    private let disposeBag = DisposeBag()
    
    public private(set) lazy var input: EventsViewModelInput = Input(
        update: updateSubject.asObserver(),
        refresh: refreshSubject.asObserver(),
        selectedEvent: selectedEvent.asObserver(),
        favouriteToggle: favouriteToggle.asObserver()
    )
    public private(set) lazy var output: EventsViewModelOutput = Output(
        eventsState: eventsStateSubject
            .startWith(.loading)
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: .idle( []))
    )
}

// MARK: - EventsViewModelType

extension EventsViewModel {
    struct Input: EventsViewModelInput {
        let update: AnyObserver<Void>
        let refresh: AnyObserver<Void>
        let selectedEvent: AnyObserver<Domain.Event>
        let favouriteToggle: AnyObserver<Domain.Event>
    }
    struct Output: EventsViewModelOutput {
        var eventsState: Driver<EventsState>
    }
}

private extension EventsViewModel {
    
    func registerObserver() {
        
        Observable.merge(
            dependencies.eventsUseCase.events.map({ EventsState.idle($0) }),
            update(),
            refresh()
        )
            .subscribe(eventsStateSubject)
            .disposed(by: disposeBag)
        
        selectedEvent
            .flatMap({ [unowned self] (event: Domain.Event) -> Observable<Void> in
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
    
    func update() -> Observable<EventsState> {
        updateSubject.flatMapLatest({ [unowned self] _ in
            Observable.create({ [unowned self] observer in
                observer.onNext(.updating)
                
                return self.dependencies.eventsUseCase.update()
                    .catchError({ _ in Completable.empty() })
                    .andThen(dependencies.eventsUseCase.events.take(1))
                    .map({ EventsState.idle($0) })
                    .subscribe(observer)
            })
        })
    }
    
    func refresh() -> Observable<EventsState> {
        refreshSubject.flatMapLatest({ [unowned self] _ in
            Observable.create({ [unowned self] observer in
                observer.onNext(EventsState.refreshing)
                
                return self.dependencies.eventsUseCase.refresh()
                    .catchError({ _ in Completable.empty() })
                    .andThen(dependencies.eventsUseCase.events.take(1))
                    .map({ EventsState.idle($0) })
                    .subscribe(observer)
            })
        })
    }
}
