//
//  SettingsService.swift
//  Weather
//
//  Created by Sergey V. Krupov on 29.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Foundation
import RxSwift

protocol SettingsService {

    var baseURL: URL { get }

    var secret: String { get }

    var allCities: Observable<[City]> { get }

    var currentCity: Observable<City> { get }

    func setCurrentCityID(_ id: Int)
}

final class SettingsComponent: SettingsService {

    let baseURL: URL = URL(string: "https://api.openweathermap.org")!

    let secret = "77abbce3f579492502ecb93387c50f1b"

    let selectedСityID = ReplaySubject<Int?>.create(bufferSize: 1)

    init() {
        let identifier = UserDefaults.standard.object(forKey: currentCityIDKey) as? Int
        selectedСityID.onNext(identifier)
    }

    var allCities: Observable<[City]> = {
        return Observable.deferred { () -> Observable<[City]> in
                do {
                    let data = try Data(contentsOf: R.file.citiesJson()!)
                    let cities = try JSONDecoder().decode(Array<City>.self, from: data)
                    return .just(cities)
                } catch {
                    return .error(error)
                }
            }
            .share(replay: 1, scope: .forever)
    }()

    var currentCity: Observable<City> {
        return Observable.combineLatest(allCities.asObservable(), selectedСityID.asObserver())
            .flatMap { tuple -> Maybe<City> in
                let (cities, identifier) = tuple

                guard let city = cities.first(where: { $0.id == identifier }) else {
                    return .just(cities.first!)
                }

                return .just(city)
            }
    }

    func setCurrentCityID(_ id: Int) {
        UserDefaults.standard.set(id, forKey: currentCityIDKey)
        selectedСityID.onNext(id)
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()
    private let currentCityIDKey = "current.city.identifier"
}
