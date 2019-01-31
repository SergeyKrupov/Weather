//
//  ForecastForecastAssemblyContainer.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class ForecastAssemblyContainer: Assembly {

    func assemble(container: Container) {
        container.register(ForecastInteractorProtocol.self) { resolver in
            let interactor = ForecastInteractor()
            interactor.weatherService = resolver.resolve(WeatherService.self)!
            interactor.settingsService = resolver.resolve(SettingsService.self)!
            return interactor
        }

        container.register(ForecastRouterProtocol.self) { (_, _: ForecastViewController) in
            let router = ForecastRouter()
            return router
        }

        container.register(ForecastPresenter.self) { (resolver, viewController: ForecastViewController) in
            let presenter = ForecastPresenter()
            presenter.view = viewController
            presenter.interactor = resolver.resolve(ForecastInteractorProtocol.self)
            presenter.router = resolver.resolve(ForecastRouterProtocol.self, argument: viewController)
            return presenter
        }

        container.storyboardInitCompleted(ForecastViewController.self) { resolver, viewController in
            let presenter = resolver.resolve(ForecastPresenter.self, argument: viewController)!
            viewController.setPresenter(presenter)
        }
    }
}
