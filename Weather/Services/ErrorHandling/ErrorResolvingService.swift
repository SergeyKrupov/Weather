//
//  ErrorResolvingService.swift
//  Weather
//
//  Created by Sergey V. Krupov on 04.03.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxSwift

enum ErrorResolution {
    case retry
    case pass
}

typealias ErrorResolver = (Error, ErrorResolution) -> Void

protocol ErrorResolvingService {

    var errors: Observable<(Error, ErrorResolver)?> { get }
}
