//
//  TestScheduler+Helpers.swift
//  PlatformTests
//
//  Created by Sergey Pugach on 22.05.21.
//

import RxSwift
import RxRelay
import RxTest

// MARK: - Recording

extension TestScheduler {
    
    /// Creates a `TestableObserver` instance which immediately subscribes
    /// to the `source` and disposes the subscription at virtual time 1000.
    @discardableResult
    public func record<Observable: ObservableConvertibleType>(_ source: Observable) -> TestableObserver<Observable.Element> {
        
        let observer = createObserver(Observable.Element.self)
        let disposable = source.asObservable().subscribe(observer)
        
        scheduleAt(1000) { disposable.dispose() }
        
        return observer
    }
}


//MARK: - Hot binding

extension TestScheduler {
    
    @discardableResult
    public func hotBinding<Observer: ObserverType>(events: [Recorded<Event<Observer.Element>>], to observer: Observer) -> TestableObservable<Observer.Element> {
        
        let observable = createHotObservable(events)
        let disposable = observable.subscribe(observer)
        scheduleAt(1000) { disposable.dispose() }
        
        return observable
    }
    
    @discardableResult
    public func hotBinding<Element>(events: [Recorded<Event<Element>>], to relay: PublishRelay<Element>) -> TestableObservable<Element> {
        
        let observable = createHotObservable(events)
        let disposable = observable.bind(to: relay)
        scheduleAt(1000) { disposable.dispose() }
        
        return observable
    }
    
    @discardableResult
    public func hotBinding<Element>(events: [Recorded<Event<Element>>], to relay: BehaviorRelay<Element>) -> TestableObservable<Element> {
        
        let observable = createHotObservable(events)
        let disposable = observable.bind(to: relay)
        scheduleAt(1000) { disposable.dispose() }
        
        return observable
    }
}
    

// MARK: - Cold binding

extension TestScheduler {
    
    @discardableResult
    public func coldBinding<Observer: ObserverType>(events: [Recorded<Event<Observer.Element>>], to observer: Observer) -> TestableObservable<Observer.Element> {
        
        let observable = createColdObservable(events)
        let disposable = observable.subscribe(observer)
        scheduleAt(1000) { disposable.dispose() }
        
        return observable
    }
    
    @discardableResult
    public func coldBinding<Element>(events: [Recorded<Event<Element>>], to relay: PublishRelay<Element>) -> TestableObservable<Element> {
        
        let observable = createColdObservable(events)
        let disposable = observable.bind(to: relay)
        scheduleAt(1000) { disposable.dispose() }
        
        return observable
    }
    
    @discardableResult
    public func coldBinding<Element>(events: [Recorded<Event<Element>>], to relay: BehaviorRelay<Element>) -> TestableObservable<Element> {
        
        let observable = createColdObservable(events)
        let disposable = observable.bind(to: relay)
        scheduleAt(1000) { disposable.dispose() }
        
        return observable
    }
}
