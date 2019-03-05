//
//  ErrorHandlingServiceAssembly.swift
//  Weather
//
//  Created by Sergey on 03/03/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject

final class ErrorHandlingServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(ErrorHandlingService.self) { _ in
            ErrorHandlingComponent()
        }
        .implements(ErrorResolvingService.self)
    }
}
