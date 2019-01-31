//
//  WeatherService.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxSwift

protocol WeatherService {

    func obtainWeather(for city: City) -> Single<Weather>

    func obtainForecast(for city: City) -> Single<[Weather]>
}

final class WeatherComponent: WeatherService {

    // MARK: - Dependencies
    var networkService: NetworkService!
    var settingsService: SettingsService!

    // Текущая погода
    func obtainWeather(for city: City) -> Single<Weather> {
        let url = settingsService.baseURL.appendingPathComponent("data/2.5/weather")
        let parameters: [String: Any] = [
            "id": city.id,
            "appid": settingsService.secret,
            "units": "metric"
        ]

        return networkService.jsonRequest(url: url, parameters: parameters)
            .map { (response: API.Weather) -> Weather in
                return self.mapResponse(response)
            }
    }

    // Прогноз на несколько дней
    func obtainForecast(for city: City) -> Single<[Weather]> {
        let url = settingsService.baseURL.appendingPathComponent("data/2.5/forecast")
        let parameters: [String: Any] = [
            "id": city.id,
            "appid": settingsService.secret,
            "units": "metric"
        ]

        return networkService.jsonRequest(url: url, parameters: parameters)
            .map { (response: API.Forecast) -> [Weather] in
                return response.items.map(self.mapResponse)
            }
    }

    // MARK: - Private
    private func mapResponse(_ weather: API.Weather) -> Weather {
        return Weather(
            temperature: weather.temperature,
            minTemperature: weather.minTemperature,
            maxTemperature: weather.maxTemperature,
            pressure: weather.pressure,
            humidity: weather.humidity,
            date: weather.date,
            icon: weather.icon,
            description: weather.description
        )
    }
}
