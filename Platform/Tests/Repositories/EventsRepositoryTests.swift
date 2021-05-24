//
//  EventsRepositoryTests.swift
//  PlatformTests
//
//  Created by Sergey Pugach on 22.05.21.
//

import XCTest
import Domain
import RxTest
import RxSwift
@testable import Platform

class EventsRepositoryTests: XCTestCase {
    
    var networkMock: NetworkServiceMock!
    var storageMock: StorageServiceMock!
    var repository: EventsRepositoryProtocol!
    
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        
        scheduler = TestScheduler(initialClock: 0)
        
        networkMock = NetworkServiceMock()
        storageMock = StorageServiceMock()
        repository = EventsRepository(
            dependencies: EventsRepository.Dependencies(
                networkService: networkMock,
                storageService: storageMock
                )
        )
    }
    
    override func tearDown() {
        scheduler = nil
        networkMock = nil
        storageMock = nil
        repository = nil
        super.tearDown()
    }
    
    func testEvents() {
        
        let record = scheduler.record(repository.events)
        let events = Domain.Event.make(3)
        
        scheduler.coldBinding(
            events: [
                .next(10, .success(events.data))
            ],
            to: storageMock.listenSubject
        )

        scheduler.start()

        XCTAssertEqual(record.events, [
            .next(0, []),
            .next(10, events)
        ])
    }
    
    func testRefresh() {
        
        var recordedEvent: [CompletableTimeEvent] = []
        
        (1...4)
            .map({ $0 * 10 })
            .forEach({ time in
            scheduler.scheduleAt(time) {
                _ = self.repository.refresh()
                    .subscribe { recordedEvent.append(.init(time: self.scheduler.clock, event: $0)) }
            }
        })
        
        scheduler.coldBinding(
            events: [
                .next(12, .failure(RxError.unknown)),
                .next(22, .success(Container(events: .events(3)).data)),
                .next(32, .success(Container(events: .events(3)).data)),
                .next(42, .success(Container(events: .events(3)).data)),
            ],
            to: networkMock.requestSubject
        )
        
        scheduler.coldBinding(events: [
            .next(23, .failure(RxError.unknown)),
            .next(33, .success(())),
            .next(43, .success(()))
        ], to: storageMock.setSubject)
        
        scheduler.coldBinding(events: [
            .next(34, .failure(RxError.unknown)),
            .next(44, .success(())),
        ], to: storageMock.setSubject)
        
        scheduler.start()
        
        XCTAssertEqual(recordedEvent, [
            .init(time: 12, event: .error(RxError.unknown)),
            .init(time: 23, event: .error(RxError.unknown)),
            .init(time: 34, event: .error(RxError.unknown)),
            .init(time: 44, event: .completed)
        ])
    }
    
    func testUpdate() {
        
        var recordedEvent: [CompletableTimeEvent] = []
        
        (1...3)
            .map({ $0 * 10 })
            .forEach({ time in
            scheduler.scheduleAt(time) {
                _ = self.repository.update()
                    .subscribe { recordedEvent.append(.init(time: self.scheduler.clock, event: $0)) }
            }
        })
        
        scheduler.coldBinding(
            events: [
                .next(11, .success(try! Date().encode())),
                .next(21, .failure(RxError.unknown)),
                .next(31, .success(try! Date(timeIntervalSinceNow: -TimeInterval.hour - 1).encode()))
            ],
            to: storageMock.getSubject
        )
        
        scheduler.coldBinding(
            events: [
                .next(22, .success(Container(events: .events(3)).data)),
                .next(32, .success(Container(events: .events(3)).data)),
            ],
            to: networkMock.requestSubject
        )
        
        scheduler.coldBinding(events: [
            .next(23, .success(())),
            .next(33, .success(())),
        ], to: storageMock.setSubject)
        
        scheduler.coldBinding(events: [
            .next(24, .success(())),
            .next(34, .success(())),
        ], to: storageMock.setSubject)
        
        scheduler.start()
        
        XCTAssertEqual(recordedEvent, [
            .init(time: 11, event: .completed),
            .init(time: 24, event: .completed),
            .init(time: 34, event: .completed)
        ])
    }
    
    func testSet() {
        
        var recordedEvent: [CompletableTimeEvent] = []
        
        (1...2)
            .map({ $0 * 10 })
            .forEach({ time in
            scheduler.scheduleAt(time) {
                _ = self.repository.set(Domain.Event.make(3))
                    .subscribe { recordedEvent.append(.init(time: self.scheduler.clock, event: $0)) }
            }
        })
        
        scheduler.coldBinding(events: [
            .next(11, .failure(RxError.unknown)),
            .next(21, .success(())),
        ], to: storageMock.setSubject)
        
        scheduler.start()
        
        XCTAssertEqual(recordedEvent, [
            .init(time: 11, event: .error(RxError.unknown)),
            .init(time: 21, event: .completed),
        ])
    }
}
