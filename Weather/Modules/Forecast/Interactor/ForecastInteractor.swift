//
//  ForecastForecastInteractor.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

final class ForecastInteractor: ForecastInteractorProtocol {

    // MARK: - Dependencies
    var weatherService: WeatherService!
    var settingsService: SettingsService!
    var errorHandlingService: ErrorHandlingService!

    // MARK: - ForecastInteractorProtocol
    lazy var forecast: Driver<[Weather]> = {
        let refreshObservable = refreshSubject.startWith(())
        return Observable.combineLatest(refreshObservable, settingsService.currentCity) { $1 }
            .flatMapLatest { [service = self.weatherService!] city in service.obtainForecast(for: city) }
            .retryWhen(errorHandlingService.retryTrigger)
            .catchError { _ in .empty() }
            .asDriver(onErrorDriveWith: .empty())
    } ()

    func refresh() {
        refreshSubject.onNext(())
    }

    // MARK: - Private
    private let refreshSubject = PublishSubject<Void>()
}
