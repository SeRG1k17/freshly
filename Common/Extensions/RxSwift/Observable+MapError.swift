//
//  Observable+MapError.swift
//  Freshly
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation
import RxSwift


public protocol MappableError: Error {
    init(error: Error)
}


// MARK: - Observable

extension ObservableType {
    public func mapErrorTo(_ mappableError: MappableError.Type) -> Observable<Element> {
        return catchError { (error: Error) -> Observable<Element> in
            return .error(mappableError.init(error: error))
        }
    }
}


// MARK: - Single

extension PrimitiveSequence where Trait == SingleTrait {
    public func mapErrorTo(_ mappableError: MappableError.Type) -> PrimitiveSequence<Trait, Element> {
        return catchError { (error: Error) -> PrimitiveSequence<Trait, Element> in
            return .error(mappableError.init(error: error))
        }
    }
}


// MARK: - Maybe

extension PrimitiveSequence where Trait == MaybeTrait {
    public func mapErrorTo(_ mappableError: MappableError.Type) -> PrimitiveSequence<Trait, Element> {
        return catchError { (error: Error) -> PrimitiveSequence<Trait, Element> in
            return .error(mappableError.init(error: error))
        }
    }
}


// MARK: - Completable

extension PrimitiveSequence where Trait == CompletableTrait, Element == Never {
    public func mapErrorTo(_ mappableError: MappableError.Type) -> PrimitiveSequence<Trait, Element> {
        return catchError { (error: Error) -> PrimitiveSequence<Trait, Element> in
            return .error(mappableError.init(error: error))
        }
    }
}
