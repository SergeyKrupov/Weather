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

    init() {
        queue = DispatchQueue(label: "ErrorHandlingComponent queue")
        scheduler = SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: queue.label)
    }

    var retryTrigger: RetryTrigger {
        return { errors -> Observable<Void> in
            errors.flatMap {
                    self.enqueueError($0)
                        .andThen(self.waitResolution(for: $0))
                }
                .map { _ in }
        }
    }

    var currentError: Observable<Error?> {
        return errorsQueue
            .map { $0.first?.error }
    }

    func ignoreError() {
        queue.async {
            var errors = (try? self.errorsQueue.value()) ?? []
            if !errors.isEmpty {
                let currentError = errors.removeFirst()
                self.resolveSubject.onNext((false, currentError))
                self.errorsQueue.onNext(errors)
            }
        }
    }

    func retryRequest() {
        //FIXME
        queue.async {
            var errors = (try? self.errorsQueue.value()) ?? []
            if !errors.isEmpty {
                let currentError = errors.removeFirst()
                self.resolveSubject.onNext((true, currentError))
                self.errorsQueue.onNext(errors)
            }
        }
    }

    private var errorsQueue = BehaviorSubject<[ErrorHolder]>(value: [])
    private let resolveSubject = PublishSubject<(Bool, ErrorHolder)>()
    private let queue: DispatchQueue
    private let scheduler: SerialDispatchQueueScheduler

    private func enqueueError(_ error: Error) -> Completable {
        return Completable.create { observer -> Disposable in
            let holder = ErrorHolder(error: error)
            var errors = (try? self.errorsQueue.value()) ?? []
            if !errors.contains(holder) {
                errors.append(holder)
            }
            self.errorsQueue.onNext(errors)
            observer(.completed)
            return Disposables.create()
        }
        .subscribeOn(scheduler)
    }

    private func waitResolution(for error: Error) -> Observable<Bool> {
        let holder = ErrorHolder(error: error)
        return resolveSubject
            .filter { $0.1 == holder }
            .map { $0.0 }
    }
}

private struct ErrorHolder: Equatable {
    let error: Error

    static func == (lhs: ErrorHolder, rhs: ErrorHolder) -> Bool {
        let lhsError = lhs.error as NSError
        let rhsError = rhs.error as NSError

        return lhsError.domain == rhsError.domain && lhsError.code == rhsError.code
    }
}
