//
//  NetworkServiceAssembly.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject

final class NetworkServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(NetworkService.self) { _ in
            return NetworkComponent()
        }
        .inObjectScope(.container)
    }
}
