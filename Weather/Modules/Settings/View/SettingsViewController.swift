//
//  SettingsSettingsViewController.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Public
    func setPresenter(_ presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 45
        tableView.register(R.nib.settingsCityCell)

        let dataSource = RxTableViewSectionedReloadDataSource<CitiesSection>(configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsCityCell, for: indexPath)!
            cell.setup(item)
            return cell
        }, titleForHeaderInSection: { dataSource, section in
            return dataSource.sectionModels[section].header
        })

        sectionsRelay.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        presenter?.setupBindings(self)
    }

    // MARK: - Private
    private var presenter: SettingsPresenterProtocol?
    private let sectionsRelay = PublishRelay<[CitiesSection]>()
    private let disposeBag = DisposeBag()
}

// MARK: - SettingsViewInput
extension SettingsViewController: SettingsViewProtocol {

    var sections: Binder<[CitiesSection]> {
        return Binder(self) { this, sections in
            this.sectionsRelay.accept(sections)
        }
    }

    var citySelected: ControlEvent<CityItem> {
        return tableView.rx.modelSelected(CityItem.self)
    }
}
