//
//  SettingsSettingsInteractorProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

protocol SettingsInteractorProtocol: class {

    // MARK: - Output
    var cities: Driver<[City]> { get }
    var selectedCity: Driver<City> { get }

    // MARK: - Input
    var selectedCityIDSink: Binder<Int> { get }
}
