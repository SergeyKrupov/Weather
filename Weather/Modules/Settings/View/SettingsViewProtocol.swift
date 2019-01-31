//
//  SettingsSettingsViewProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

protocol SettingsViewProtocol: class {

    // MARK: - Input
    var sections: Binder<[CitiesSection]> { get }

    // MARK: - Output
    var citySelected: ControlEvent<CityItem> { get }
}
