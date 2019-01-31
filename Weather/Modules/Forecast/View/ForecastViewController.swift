//
//  ForecastForecastViewController.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class ForecastViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Public
    func setPresenter(_ presenter: ForecastPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 45
        tableView.refreshControl = refreshControl
        tableView.register(R.nib.forecastItemCellTableViewCell)
        itemsRelay.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: R.reuseIdentifier.forecastItemCellTableViewCell.identifier)) { _, model, cell in
                let weatherCell = cell as! ForecastItemCellTableViewCell
                weatherCell.setup(model)
            }
            .disposed(by: disposeBag)

        presenter?.setupBindings(self)
    }

    // MARK: - Private
    private var presenter: ForecastPresenterProtocol?
    private let itemsRelay = PublishRelay<[WeatherItem]>()
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl(frame: .zero)
}

// MARK: - ForecastViewInput
extension ForecastViewController: ForecastViewProtocol {

    var items: Binder<[WeatherItem]> {
        return Binder(self) { this, items in
            this.itemsRelay.accept(items)
        }
    }

    var refresh: ControlEvent<Void> {
        return refreshControl.rx.controlEvent(.valueChanged)
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
