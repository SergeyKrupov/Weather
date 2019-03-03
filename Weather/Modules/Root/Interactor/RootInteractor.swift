//
//  RootRootInteractor.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

final class RootInteractor: RootInteractorProtocol {

    // MARK: - Dependencies
    var errorResolvingService: ErrorResolvingService!

    // MARK: - RootInteractorProtocol
    private(set) lazy var currentError: Driver<Error?> = {
        return errorResolvingService.currentError
            .asDriver(onErrorJustReturn: nil)
    } ()

    func ignoreError() {
        errorResolvingService.ignoreError()
    }

    func retryRequest() {
        errorResolvingService.retryRequest()
    }
}
