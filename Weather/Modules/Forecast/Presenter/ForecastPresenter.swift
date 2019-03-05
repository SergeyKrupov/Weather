//
//  ForecastForecastPresenter.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

final class ForecastPresenter {

    // MARK: - Properties
    var interactor: ForecastInteractorProtocol!
    var router: ForecastRouterProtocol!
    weak var view: ForecastViewProtocol?

    // MARK: - Public

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - ForecastPesenterProtocol
extension ForecastPresenter: ForecastPresenterProtocol {

    func setupBindings(_ view: ForecastViewProtocol) {
        interactor.forecast
            .flatMap { Driver.from(optional: $0.value) }
            .map { weathers -> [WeatherItem] in
                weathers.map {
                    WeatherItem(
                        image: UIImage(named: $0.icon) ?? R.image.undefined(),
                        description: $0.description,
                        temperature: Utils.temperatureFormatter.string(from: $0.temperature as NSNumber),
                        date: Utils.dateFormatter.string(from: $0.date)
                    )
                }
            }
            .drive(view.items)
            .disposed(by: disposeBag)

        view.refresh
            .bind(to: Binder(self) { this, _ in
                this.interactor.refresh()
            })
            .disposed(by: disposeBag)

        interactor.forecast
            .drive(Binder(self) { this, _ in
                this.view?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ForecastModuleInput
extension ForecastPresenter: ForecastModuleInput {
}
