//
//  ErrorHandlingComponent.swift
//  Weather
//
//  Created by Sergey V. Krupov on 04.03.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Foundation
import RxSwift

final class ErrorHandlingComponent: ErrorHandlingService, ErrorResolvingService {

    init() {
        queue = DispatchQueue(label: "ErrorHandlingComponent queue")
        scheduler = SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: queue.label)
    }

    var retryTrigger: RetryTrigger {
        return { errors in
            errors.flatMap { error in
                self.enqueueError(error)
                    .andThen(self.waitResolution(for: error))
                    .map { ($0, error) }
            }
            .flatMap { tuple -> Observable<Void> in
                let (resolution, error) = tuple
                return resolution == .pass ? .error(error) : .just(())
            }
        }
    }

    var errors: Observable<(Error, ErrorResolver)?> {

        let resolver: ErrorResolver = { [queue, stateSubject] error, resolution in
            queue.async {
                let state = (try? stateSubject.value()) ?? .noErrors
                let holder = ErrorHolder(error: error)

                switch state {
                case .noErrors:
                    assertionFailure("Некорректное состояние: разрешена несуществующая ошибка")
                    return
                case let .processing(error: current, queued: queued):
                    let resolved: State = .resolved(error: current, resolution: resolution, queued: queued)
                    assert(current == holder, "Некорректное состояние: разрешена не текущая ошибка")
                    stateSubject.onNext(resolved)

                    if let nextError = queued.first {
                        let processing: State = .processing(error: nextError, queued: Array(queued.suffix(from: 1)))
                        stateSubject.onNext(processing)
                    } else {
                        stateSubject.onNext(.noErrors)
                    }

                case let .resolved(error: _, resolution: _, queued: queued):
                    assertionFailure("Некорректное состояние: одна и та же ошибка разрешена дважды")

                    if let nextError = queued.first {
                        let processing: State = .processing(error: nextError, queued: Array(queued.suffix(from: 1)))
                        stateSubject.onNext(processing)
                    } else {
                        stateSubject.onNext(.noErrors)
                    }
                }
            }
        }

        return stateSubject
            .map { state -> (Error, ErrorResolver)? in
                if case let .processing(error: holder, queued: _) = state {
                    return (holder.error, resolver)
                }
                return nil
            }
    }

    // MARK: - Private

    private enum State {
        case noErrors
        case processing(error: ErrorHolder, queued: [ErrorHolder])
        case resolved(error: ErrorHolder, resolution: ErrorResolution, queued: [ErrorHolder])
    }

    private let queue: DispatchQueue
    private let scheduler: SerialDispatchQueueScheduler

    private let stateSubject = BehaviorSubject<State>(value: .noErrors)

    private func enqueueError(_ error: Error) -> Completable {
        return Completable.create { [stateSubject] observer -> Disposable in
            let state = (try? stateSubject.value()) ?? .noErrors

            let holder = ErrorHolder(error: error)
            switch state {
            case .noErrors:
                stateSubject.onNext(.processing(error: holder, queued: []))
            case let .processing(error: current, queued: queued):
                let allErrors = [current] + queued
                if !allErrors.contains(holder) {
                    stateSubject.onNext(.processing(error: current, queued: queued + [holder]))
                }
            case let .resolved(error: processed, resolution: resolution, queued: queued):
                if !queued.contains(holder) {
                    stateSubject.onNext(.resolved(error: processed, resolution: resolution, queued: queued + [holder]))
                }
            }

            observer(.completed)
            return Disposables.create()
        }
        .subscribeOn(scheduler)
    }

    private func waitResolution(for error: Error) -> Observable<ErrorResolution> {
        let holder = ErrorHolder(error: error)
        return stateSubject
            .flatMap { state -> Maybe<ErrorResolution> in
                if case let .resolved(error: processed, resolution: resolution, queued: _) = state, processed == holder {
                    return .just(resolution)
                }
                return .empty()
            }
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
