//
//  RootRootInteractorProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

protocol RootInteractorProtocol: class {

    var currentError: Driver<Error?> { get }

    func ignoreError()

    func retryRequest()
}
