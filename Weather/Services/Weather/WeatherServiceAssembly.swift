//
//  WeatherServiceAssembly.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject

final class WeatherServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(WeatherService.self) { resolver in
            let component = WeatherComponent()
            component.networkService = resolver.resolve(NetworkService.self)!
            component.settingsService = resolver.resolve(SettingsService.self)!
            return component
        }
    }
}
