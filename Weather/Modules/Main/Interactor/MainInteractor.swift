//
//  MainMainInteractor.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

final class MainInteractor: MainInteractorProtocol {

    // MARK: - Dependencies
    var weatherService: WeatherService!
    var settingsService: SettingsService!
    var errorHandlingService: ErrorHandlingService!

    // MARK: - MainInteractorProtocol
    private(set) lazy var weather: Driver<Result<Weather>> = {
        let refreshObservable = refreshSubject.startWith(())
        return Observable.combineLatest(refreshObservable, settingsService.currentCity) { $1 }
            .flatMapLatest { [service = self.weatherService!, retryTrigger = errorHandlingService.retryTrigger] city in
                service.obtainWeather(for: city)
                    .asObservable()
                    .retryWhen(retryTrigger)
                    .map { Result.success($0) }
                    .catchError { error in .just(.failure(error)) }
            }
            .asDriver(onErrorDriveWith: .empty())
    }()

    private(set) lazy var city: Driver<String?> = {
        return settingsService.currentCity
            .retryWhen(errorHandlingService.retryTrigger)
            .catchError { _ in .empty() }
            .asDriver(onErrorDriveWith: .empty())
            .map { $0.name }
    }()

    func refresh() {
        refreshSubject.onNext(())
    }

    // MARK: - Private
    private let refreshSubject = PublishSubject<Void>()
}
