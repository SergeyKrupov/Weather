//
//  MainMainAssemblyContainer.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class MainAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(MainInteractorProtocol.self) { resolver in
            let interactor = MainInteractor()
            interactor.weatherService = resolver.resolve(WeatherService.self)!
            interactor.settingsService = resolver.resolve(SettingsService.self)!
			return interactor
		}

		container.register(MainRouterProtocol.self) { (_, _: MainViewController) in
			let router = MainRouter()
			return router
		}

		container.register(MainPresenter.self) { (resolver, viewController: MainViewController) in
			let presenter = MainPresenter()
			presenter.view = viewController
			presenter.interactor = resolver.resolve(MainInteractorProtocol.self)
			presenter.router = resolver.resolve(MainRouterProtocol.self, argument: viewController)
			return presenter
		}

		container.storyboardInitCompleted(MainViewController.self) { resolver, viewController in
			let presenter = resolver.resolve(MainPresenter.self, argument: viewController)!
            viewController.setPresenter(presenter)
		}
	}
}
