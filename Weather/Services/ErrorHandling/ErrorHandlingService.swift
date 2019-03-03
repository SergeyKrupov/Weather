//
//  ErrorHandlingService.swift
//  Weather
//
//  Created by Sergey on 03/03/2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxSwift

typealias RetryTrigger = (Observable<Error>) -> Observable<Void>

protocol ErrorHandlingService {

    var retryTrigger: RetryTrigger { get }
}

protocol ErrorResolvingService {

    var currentError: Observable<Error?> { get }

    func ignoreError()

    func retryRequest()
}

final class ErrorHandlingComponent: ErrorHandlingService, ErrorResolvingService {

    var retryTrigger: RetryTrigger {
        return { errors -> Observable<Void> in
            return errors.flatMap { _ in
                Observable.just(()).delay(1, scheduler: MainScheduler.instance)
            }
        }
    }

    var currentError: Observable<Error?> {
        return .never()
    }

    func ignoreError() {
    }

    func retryRequest() {
    }
}
