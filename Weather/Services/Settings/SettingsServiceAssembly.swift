//
//  SettingsServiceAssembly.swift
//  Weather
//
//  Created by Sergey V. Krupov on 29.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject

final class SettingsServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SettingsService.self) { _ in
            return SettingsComponent()
        }
        .inObjectScope(.container)
    }
}
