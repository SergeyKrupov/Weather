//
//  RootRootRouter.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxSwift
import UIKit

final class RootRouter: RootRouterProtocol {

    // MARK: - Dependencies
    weak var viewController: UIViewController?

    func presentError(_ error: Error) -> Single<Bool> {
        return Single.create { action -> Disposable in
            guard let viewController = self.viewController else {
                action(.success(false))
                return Disposables.create()
            }

            let alert = UIAlertController(title: R.string.localizable.alert_title_error(),
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.alert_button_retry(), style: .default) { _ in
                action(.success(true))
            })
            alert.addAction(UIAlertAction(title: R.string.localizable.alert_button_skip(), style: .default) { _ in
                action(.success(false))
            })

            viewController.present(alert, animated: true, completion: nil)
            return Disposables.create { [weak alert] in
                DispatchQueue.main.async {
                    if let viewController = alert?.presentingViewController {
                        viewController.dismiss(animated: true)
                    }
                }
            }
        }
        .subscribeOn(MainScheduler.instance)
    }
}
