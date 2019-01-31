//
//  SettingsSettingsInteractor.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

final class SettingsInteractor: SettingsInteractorProtocol {

    // MARK: - Dependencies
    var settingsService: SettingsService!

    // MARK: - SettingsInteractorProtocol
    lazy var cities: Driver<[City]> = {
        settingsService.allCities
            .asDriver(onErrorDriveWith: .empty())
    } ()

    lazy var selectedCity: Driver<City> = {
        settingsService.currentCity
            .asDriver(onErrorDriveWith: .empty())
    } ()

    var selectedCityIDSink: Binder<Int> {
        return Binder(self) { this, identifier in
            this.settingsService.setCurrentCityID(identifier)
        }
    }
}
