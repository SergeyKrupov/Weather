//
//  SettingsSettingsPresenter.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

final class SettingsPresenter {

    // MARK: - Properties
    var interactor: SettingsInteractorProtocol!
    var router: SettingsRouterProtocol!
    weak var view: SettingsViewProtocol?

    // MARK: - Private
    private let disposeBag = DisposeBag()
}

// MARK: - SettingsPesenterProtocol
extension SettingsPresenter: SettingsPresenterProtocol {

    func setupBindings(_ view: SettingsViewProtocol) {
        Driver.combineLatest(interactor.cities, interactor.selectedCity) { cities, currentCity -> [CitiesSection] in
                let items = cities.map {
                    CityItem(
                        name: $0.name,
                        isCurrent: $0.id == currentCity.id,
                        id: $0.id
                    )
                }
                return [CitiesSection(header: "Город", items: items)]
            }
            .drive(view.sections)
            .disposed(by: disposeBag)

        view.citySelected
            .map { $0.id }
            .bind(to: interactor.selectedCityIDSink)
            .disposed(by: disposeBag)
    }
}

// MARK: - SettingsModuleInput
extension SettingsPresenter: SettingsModuleInput {
}
