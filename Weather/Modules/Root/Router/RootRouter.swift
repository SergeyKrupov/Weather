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

            //TODO: Localizable
            let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
                action(.success(true))
            })
            alert.addAction(UIAlertAction(title: "Пропустить", style: .default) { _ in
                action(.success(false))
            })

            viewController.present(alert, animated: true, completion: nil)
            return Disposables.create() // FIXME
        }
        .subscribeOn(MainScheduler.instance)
    }
}
