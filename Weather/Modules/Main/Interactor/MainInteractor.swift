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

    // MARK: - MainInteractorProtocol
    lazy var weather: Driver<Weather> = {
        let refreshObservable = refreshSubject.startWith(())
        return Observable.combineLatest(refreshObservable, settingsService.currentCity) { $1 }
            .flatMapLatest { [service = self.weatherService!] city in service.obtainWeather(for: city) }
            .catchError { _ in .empty() }
            .asDriver(onErrorDriveWith: .empty())
    } ()

    lazy var city: Driver<String?> = {
        return settingsService.currentCity
            .catchError { _ in .empty() }
            .asDriver(onErrorDriveWith: .empty())
            .map { $0.name }
    } ()

    func refresh() {
        refreshSubject.onNext(())
    }

    // MARK: - Private
    private let refreshSubject = PublishSubject<Void>()
}
