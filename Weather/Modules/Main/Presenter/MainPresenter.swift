//
//  MainMainPresenter.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class MainPresenter {

    // MARK: - Properties
    var interactor: MainInteractorProtocol!
    var router: MainRouterProtocol!
    weak var view: MainViewProtocol?

    // MARK: - Private
    let disposeBag = DisposeBag()
}

// MARK: - MainPesenterProtocol
extension MainPresenter: MainPresenterProtocol {

    func setupBindings(_ view: MainViewProtocol) {

        interactor.city
            .startWith(nil)
            .drive(view.city)
            .disposed(by: disposeBag)

        interactor.weather
            .map { Utils.temperatureFormatter.string(from: $0.temperature as NSNumber) }
            .startWith("--")
            .drive(view.temperature)
            .disposed(by: disposeBag)

        interactor.weather
            .map { UIImage(named: $0.icon) ?? R.image.undefined() }
            .startWith(R.image.undefined())
            .drive(view.weatherImage)
            .disposed(by: disposeBag)

        interactor.weather
            .map { $0.description as String? }
            .startWith(nil)
            .drive(view.weatherDescription)
            .disposed(by: disposeBag)

        view.refresh
            .bind(to: Binder(self) { this, _ in
                this.interactor.refresh()
            })
            .disposed(by: disposeBag)

        interactor.weather
            .drive(Binder(self) { this, _ in
                this.view?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - MainModuleInput
extension MainPresenter: MainModuleInput {
}
