//
//  RootRootPresenter.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift

final class RootPresenter {

    // MARK: - Properties
    var interactor: RootInteractorProtocol!
    var router: RootRouterProtocol!
    weak var view: RootViewProtocol?

    // MARK: - Private
    let disposeBag = DisposeBag()
}

// MARK: - RootPesenterProtocol
extension RootPresenter: RootPresenterProtocol {

    func setupBindings(_ view: RootViewProtocol) {
        interactor.currentError
            .asObservable()
            .flatMap { [router = router!] error -> Observable<Bool> in
                guard let error = error else {
                    return .empty()
                }
                return router
                    .presentError(error)
                    .asObservable()
            }
            .subscribeOn(MainScheduler.asyncInstance) // ???
            .subscribe(onNext: { [interactor = interactor!] needsRetry in
                if needsRetry {
                    interactor.retryRequest() /// FIXME: Binder
                } else {
                    interactor.ignoreError()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - RootModuleInput
extension RootPresenter: RootModuleInput {
}
