//
//  MainMainInteractorProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

protocol MainInteractorProtocol: class {

    var weather: Driver<Result<Weather>> { get }
    var city: Driver<String?> { get }

    func refresh()
}
