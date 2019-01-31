//
//  ForecastItemCellTableViewCell.swift
//  Weather
//
//  Created by Sergey V. Krupov on 31.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import UIKit

final class ForecastItemCellTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!

    // MARK: - Public
    func setup(_ item: WeatherItem) {
        dateLabel.text = item.date
        temperatureLabel.text = item.temperature
        weatherImageView.image = item.image
    }
}
