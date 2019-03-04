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
