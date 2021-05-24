//
//  AppDI.swift
//  Freshly
//
//  Created by Sergey Pugach on 11.05.21.
//

import Foundation
import Presentation
import Platform

class AppDI: AppDIProtocol {
    
    private lazy var networkService: NetworkServiceProtocol = NetworkService()
    private lazy var storageService: StorageServiceProtocol = StorageService()
    
    private(set) lazy var eventsDI: EventsDIProtocol = {
        EventsDI(
            appEnvironment: appEnvironment,
            dependencies: .init(
                networkService: networkService,
                storageService: storageService
            )
        )
    }()
    
    private let appEnvironment: AppEnvironment
    init(appEnvironment: AppEnvironment) {
        self.appEnvironment = appEnvironment
    }
}
