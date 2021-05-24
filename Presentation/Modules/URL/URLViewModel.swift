//
//  URLViewModel.swift
//  Presentation
//
//  Created by Sergey Pugach on 18.05.21.
//

import Domain
import RxCocoa
import RxSwift

public protocol URLViewModelInput {
    var dismiss: AnyObserver<Void> { get }
}

public protocol URLViewModelOutput {
    var url: Driver<URL> { get }
}

public protocol URLViewModelType {
    var input: URLViewModelInput { get }
    var output: URLViewModelOutput { get }
}

public final class URLViewModel: URLViewModelType {
    
    private let url: URL
    private let coordinator: EventsCoordinator
    public init(url: URL, coordinator: EventsCoordinator) {
        self.url = url
        self.coordinator = coordinator
        
        registerObserver()
    }
    
    private let dismissSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    public private(set) lazy var input: URLViewModelInput = Input(
        dismiss: dismissSubject.asObserver()
    )
    public private(set) lazy var output: URLViewModelOutput = Output(
        url: Driver.just(url)
    )
}

// MARK: - URLViewModelType

extension URLViewModel {
    struct Input: URLViewModelInput {
        let dismiss: AnyObserver<Void>
    }
    struct Output: URLViewModelOutput {
        let url: Driver<URL>
    }
}

extension URLViewModel {
    
    private func registerObserver() {
        
//        updateSubject
//            .flatMap({ [unowned self] _ in
//                self.eventsUseCase.update()
//                    //.catchError({ _ in Completable.empty() })
//            })
//            .subscribe()
//            .disposed(by: disposeBag)
    }
}

