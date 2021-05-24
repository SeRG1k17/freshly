//
//  Observable+Utils.swift
//  Common
//
//  Created by Sergey Pugach on 11.05.21.
//

import RxSwift

public extension ObservableType {

    func toBool(_ value: Bool) -> Observable<Bool> {
        return map { _ in return value }
    }

    func toVoid() -> Observable<Void> {
        return map { _ in }
    }

    /**
     Combination `.take(1)` and `.asSingle()` operators.
     The operator throws a `RxError.noElements` if the Observable does not emit exactly one element before successfully completing.
     
     - returns: An observable sequence that emits a single element or throws an exception if  none of them are emitted.
     */
    func takeAsSingle() -> Single<Element> {
        return take(1)
            .asSingle()
    }

    /// Converts a Observable to Completable via Single. Ignores a `RxError.noElements` from Single
    ///
    /// - returns: Completable that represents `self`.
    func takeAsCompletable() -> Completable {
        return take(1).asSingle()
            .asCompletable()
            .catchError { error -> Completable in

                guard
                    let err = error as? RxError,
                    err.debugDescription == RxError.noElements.debugDescription
                    else { throw error }

                return .empty()
        }
    }

    func toResult() -> Observable<Result<Element, Error>> {
        return map { .success($0) }
            .catchError { .just(.failure($0)) }
    }

    func fromResult<T>() -> Observable<T> where Element == Result<T, Error> {
        return map { (result: Element) -> T in
            switch result {
            case .success(let element): return element
            case .failure(let error): throw error
            }
        }
    }

    func filterNil<T>() -> Observable<Element> where Element == T? {
        return filter { $0 != nil }
    }
}

public extension PrimitiveSequenceType where Trait == SingleTrait {

    func toResult() -> Single<Result<Element, Error>> {
        return primitiveSequence
            .asObservable()
            .toResult()
            .asSingle()
    }

    func fromResult<T>() -> Single<T> where Element == Result<T, Error> {
        return primitiveSequence
            .asObservable()
            .fromResult()
            .asSingle()
    }

    func mapTo<R>(_ value: R) -> Single<R> {
        return map { _ in value }
    }
}

public extension PrimitiveSequenceType where Trait == CompletableTrait, Element == Swift.Never {

    /**
     Dismiss errors and complete the sequence instead

     - returns: An observable sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchErrorJustComplete() -> Completable {
        return primitiveSequence.catchError { _ in .empty() }
    }
}

public extension ObservableType {

    /**
     Pauses the elements of the source observable sequence based on the latest element from the second observable sequence.

     While paused, the last element from the source are buffered

     When resumed, the latest element are flushed in a contiguous stream.

     - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)

     - parameter pauser: The observable sequence used to pause the source observable sequence.
     - returns: The observable sequence which is paused and resumed based upon the pauser observable sequence.
     */
    func pausableLast<P: ObservableType> (_ pauser: P) -> Observable<Element> where P.Element == Bool {

        return Observable<Element>.create { observer in
            var bufferElement: Element?

            var paused = false
            let lock = NSRecursiveLock()

            let flush = {
                if let bufferElement = bufferElement {
                    observer.onNext(bufferElement)
                }
                bufferElement = nil
            }

            let boundaryDisposable = pauser.distinctUntilChanged(==).subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next(let resume):
                    if resume { flush() }
                    paused = !resume

                case .completed:
                    observer.onCompleted()
                case .error(let error):
                    observer.onError(error)
                }
            }

            let disposable = self.subscribe { event in
                lock.lock(); defer { lock.unlock() }
                switch event {
                case .next(let element):
                    if paused {
                        bufferElement = element
                    } else {
                        observer.onNext(element)
                    }
                case .completed:
                    observer.onCompleted()

                case .error(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create([disposable, boundaryDisposable])
        }
    }
}
