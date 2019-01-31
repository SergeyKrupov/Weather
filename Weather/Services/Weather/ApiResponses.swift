//
//  ApiResponse.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Foundation

enum API {

    struct Weather: Decodable {

        enum RootSectionKeys: String, CodingKey {
            case main
            case weather
            case date = "dt"
        }

        enum MainSectionKeys: String, CodingKey {
            case temperature = "temp"
            case minTemperature = "temp_min"
            case maxTemperature = "temp_max"
            case pressure
            case humidity
        }

        enum WeatherSectionKeys: String, CodingKey {
            case description
            case icon
        }

        init(from decoder: Decoder) throws {
            let rootContainer = try decoder.container(keyedBy: RootSectionKeys.self)
            date = Date(timeIntervalSince1970: try rootContainer.decode(TimeInterval.self, forKey: .date))

            let mainContiner = try rootContainer.nestedContainer(keyedBy: MainSectionKeys.self, forKey: .main)
            temperature = try mainContiner.decode(Double.self, forKey: .temperature)
            minTemperature = try mainContiner.decode(Double.self, forKey: .minTemperature)
            maxTemperature = try mainContiner.decode(Double.self, forKey: .maxTemperature)
            pressure = try mainContiner.decode(Double.self, forKey: .pressure)
            humidity = try mainContiner.decode(Double.self, forKey: .humidity)

            var list = try rootContainer.nestedUnkeyedContainer(forKey: .weather)
            assert(!list.isAtEnd)
            let weatherContainer = try list.nestedContainer(keyedBy: WeatherSectionKeys.self)
            description = try weatherContainer.decode(String.self, forKey: .description)
            icon = try weatherContainer.decode(String.self, forKey: .icon)
        }

        let temperature: Double
        let minTemperature: Double
        let maxTemperature: Double
        let pressure: Double
        let humidity: Double
        let date: Date
        let description: String
        let icon: String
    }

    struct Forecast: Decodable {

        enum RootSectionKeys: String, CodingKey {
            case list
        }

        init(from decoder: Decoder) throws {
            let rootContainer = try decoder.container(keyedBy: RootSectionKeys.self)
            var list = try rootContainer.nestedUnkeyedContainer(forKey: .list)

            var items = Array<Weather>()
            while !list.isAtEnd {
                let item = try list.decode(Weather.self)
                items.append(item)
            }
            self.items = items
        }

        let items: [Weather]
    }
}
