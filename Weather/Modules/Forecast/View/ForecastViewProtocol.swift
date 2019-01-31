//
//  ForecastForecastViewProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ForecastViewProtocol: class {

    // MARK: - Input
    var items: Binder<[WeatherItem]> { get }

    // MARK: - Output
    var refresh: ControlEvent<Void> { get }

    func endRefreshing()
}
