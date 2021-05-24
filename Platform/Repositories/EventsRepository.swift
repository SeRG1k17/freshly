//
//  EventsRepository.swift
//  Platform
//
//  Created by Sergey Pugach on 11.05.21.
//

import RxSwift
import RxRelay
import Domain

public class EventsRepository {
    
    public struct Dependencies {
        let networkService: NetworkServiceProtocol
        let storageService: StorageServiceProtocol
        
        public init(networkService: NetworkServiceProtocol, storageService: StorageServiceProtocol) {
            self.networkService = networkService
            self.storageService = storageService
        }
    }
    
    private let eventsRelay = BehaviorRelay<[Domain.Event]>(value: [])
    private let disposeBag = DisposeBag()
    
    private let dependencies: Dependencies
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        registerObservers()
    }
}


// MARK: - EventsRepositoryProtocol

extension EventsRepository: EventsRepositoryProtocol {
    
    public var events: Observable<[Domain.Event]> {
        eventsRelay.asObservable()
    }
    
    public func refresh() -> Completable {
        request()
    }
    
    public func update() -> Completable {
        dependencies.storageService.get(for: Key.date.rawValue)
            .map({ (date: Date) -> Optional<Date> in Optional(date) })
            .catchErrorJustReturn(nil)
            .flatMapCompletable({ [unowned self] (date: Date?) -> Completable in
                guard date?.isValid == false || date == nil else { return .empty() }
                return self.request()
            })
    }
    
    public func set(_ events: [Domain.Event]) -> Completable {
        return setCache(items: events, for: Key.events.rawValue)
    }
}

private extension EventsRepository {
    
    func registerObservers() {
        
        dependencies.storageService
            .listen(for: Key.events.rawValue)
            .bind(to: eventsRelay)
            .disposed(by: disposeBag)
    }
    
    func request() -> Completable {
        dependencies.networkService.request(.events)
            .map({ (container: Container) -> [Domain.Event] in
                return container.events
            })
            .flatMapCompletable({ (events: [Domain.Event]) -> Completable in
                return self.set(events)
            })
            .andThen(setCache(items: Date(), for: Key.date.rawValue))
    }
    
    func setCache<T: Encodable, K: Hashable>(items: T, for key: K) -> Completable {
        dependencies.storageService.set(value: items, for: key)
    }
    
    enum Key: String {
        case events, date
    }
}

private extension Date {
    var isValid: Bool {
        guard let updatedDate = Calendar.current.date(byAdding: .hour, value: 1, to: self) else {
            return false
        }
        return updatedDate > Date()
    }
}
