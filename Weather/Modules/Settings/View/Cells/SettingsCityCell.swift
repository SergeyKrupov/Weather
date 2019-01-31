//
//  SettingsCityCell.swift
//  Weather
//
//  Created by Sergey V. Krupov on 31.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import UIKit

final class SettingsCityCell: UITableViewCell {

    func setup(_ item: CityItem) {
        textLabel?.text = item.name
        accessoryType = item.isCurrent ? .checkmark : .none
    }
}
