//
//  SettingsSettingsAssemblyContainer.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class SettingsAssemblyContainer: Assembly {

    func assemble(container: Container) {
        container.register(SettingsInteractorProtocol.self) { resolver in
            let interactor = SettingsInteractor()
            interactor.settingsService = resolver.resolve(SettingsService.self)!
            return interactor
        }

        container.register(SettingsRouterProtocol.self) { (_, _: SettingsViewController) in
            let router = SettingsRouter()
            return router
        }

        container.register(SettingsPresenter.self) { (resolver, viewController: SettingsViewController) in
            let presenter = SettingsPresenter()
            presenter.view = viewController
            presenter.interactor = resolver.resolve(SettingsInteractorProtocol.self)
            presenter.router = resolver.resolve(SettingsRouterProtocol.self, argument: viewController)
            return presenter
        }

        container.storyboardInitCompleted(SettingsViewController.self) { resolver, viewController in
            let presenter = resolver.resolve(SettingsPresenter.self, argument: viewController)!
            viewController.setPresenter(presenter)
        }
    }
}
