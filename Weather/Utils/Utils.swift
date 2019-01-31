//
//  Utils.swift
//  Weather
//
//  Created by Sergey V. Krupov on 31.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Foundation

enum Utils {

    static let temperatureFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.minimumIntegerDigits = 1
        return formatter
    } ()

    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm, dd MMMM"
        return dateFormatter
    } ()
}
