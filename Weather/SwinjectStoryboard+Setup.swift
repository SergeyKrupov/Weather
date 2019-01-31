//
//  SwinjectStoryboard+Setup.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {

    @objc
    class func setup() {
        RootAssemblyContainer().assemble(container: defaultContainer)
        MainAssemblyContainer().assemble(container: defaultContainer)
        ForecastAssemblyContainer().assemble(container: defaultContainer)
        SettingsAssemblyContainer().assemble(container: defaultContainer)
        WeatherServiceAssembly().assemble(container: defaultContainer)
        NetworkServiceAssembly().assemble(container: defaultContainer)
        SettingsServiceAssembly().assemble(container: defaultContainer)
    }
}
