//
//  RootRootAssemblyContainer.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class RootAssemblyContainer: Assembly {

    func assemble(container: Container) {
        container.register(RootInteractorProtocol.self) { resolver in
            let interactor = RootInteractor()
            interactor.errorResolvingService = resolver.resolve(ErrorResolvingService.self)!
            return interactor
        }

        container.register(RootRouterProtocol.self) { (_, _: RootViewController) in
            let router = RootRouter()
            return router
        }

        container.register(RootPresenter.self) { (resolver, viewController: RootViewController) in
            let presenter = RootPresenter()
            presenter.view = viewController
            presenter.interactor = resolver.resolve(RootInteractorProtocol.self)
            presenter.router = resolver.resolve(RootRouterProtocol.self, argument: viewController)
            return presenter
        }

        container.storyboardInitCompleted(RootViewController.self) { resolver, viewController in
            let presenter = resolver.resolve(RootPresenter.self, argument: viewController)!
            let main = R.storyboard.main.mainViewController()!
            let forecast = R.storyboard.forecast.forecastViewController()!
            let settings = R.storyboard.settings.settingsViewController()!
            viewController.pages = [main, forecast, settings]
            viewController.setPresenter(presenter)
            presenter.router.viewController = viewController
        }
    }
}
