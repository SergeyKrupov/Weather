//
//  RootRootViewController.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class RootViewController: UIPageViewController {

    // MARK: - Dependencies
    var pages: [UIViewController]!

    // MARK: - Outlets

    // MARK: - Public
    func setPresenter(_ presenter: RootPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: false)
        }
        dataSource = self
        presenter?.setupBindings(self)
    }

    // MARK: - Private
    var presenter: RootPresenterProtocol?
}

// MARK: - RootViewInput
extension RootViewController: RootViewProtocol {

    func setupInitialState() {
    }
}

extension RootViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let indexBefore = (index + pages.count - 1) % pages.count
        return pages[indexBefore]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = pages.firstIndex(of: viewController) else {
            return nil
        }
        let indexAfter = (index + 1) % pages.count
        return pages[indexAfter]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first else {
            return 0
        }
        return pages.firstIndex(of: viewController) ?? 0
    }
}
