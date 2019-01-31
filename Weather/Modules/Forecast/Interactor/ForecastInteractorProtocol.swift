//
//  ForecastForecastInteractorProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ForecastInteractorProtocol: class {

    var forecast: Driver<[Weather]> { get }

    func refresh()
}
