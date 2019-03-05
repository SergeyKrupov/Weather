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
            .flatMap { [router = router!] tuple -> Observable<(Bool, ErrorResolver, Error)> in
                guard let (error, resolver) = tuple else {
                    return .empty()
                }
                return router
                    .presentError(error)
                    .map { ($0, resolver, error) }
                    .asObservable()
            }
            .subscribe(onNext: { tuple in
                let (needsRetry, resolver, error) = tuple
                resolver(error, needsRetry ? .retry : .pass)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - RootModuleInput
extension RootPresenter: RootModuleInput {
}
