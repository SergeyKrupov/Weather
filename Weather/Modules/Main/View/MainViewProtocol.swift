//
//  MainMainViewProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa

protocol MainViewProtocol: class {

    // MARK: - Input
    var city: Binder<String?> { get }
    var temperature: Binder<String?> { get }
    var weatherImage: Binder<UIImage?> { get }
    var weatherDescription: Binder<String?> { get }

    func endRefreshing()

    // MARK: - Output
    var refresh: ControlEvent<Void> { get }
}
