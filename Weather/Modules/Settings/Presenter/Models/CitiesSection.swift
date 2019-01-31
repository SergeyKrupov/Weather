//
//  CitiesSection.swift
//  Weather
//
//  Created by Sergey V. Krupov on 31.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import RxDataSources

struct CitiesSection {
    let header: String
    let items: [CityItem]
}

extension CitiesSection: SectionModelType {

    init(original: CitiesSection, items: [CityItem]) {
        self.header = original.header
        self.items = items
    }
}
