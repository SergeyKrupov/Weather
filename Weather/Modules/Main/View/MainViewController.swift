//
//  MainMainViewController.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import UIKit

final class MainViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var weatherConditionImageView: UIImageView!
    @IBOutlet private weak var weatherConditionLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - Public
    func setPresenter(_ presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
        scrollView.addSubview(refreshControl)

        presenter?.setupBindings(self)
	}

    // MARK: - Private
    private var presenter: MainPresenterProtocol?
    private let refreshControl = UIRefreshControl(frame: .zero)
}

// MARK: - MainViewInput
extension MainViewController: MainViewProtocol {

    var city: Binder<String?> {
        return cityLabel.rx.text
    }

    var temperature: Binder<String?> {
        return currentTemperatureLabel.rx.text
    }

    var weatherImage: Binder<UIImage?> {
        return weatherConditionImageView.rx.image
    }

    var weatherDescription: Binder<String?> {
        return weatherConditionLabel.rx.text
    }

    var refresh: ControlEvent<Void> {
        return refreshControl.rx.controlEvent(.valueChanged)
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
