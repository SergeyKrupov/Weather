//
//  RootRootRouterProtocol.swift
//  Weather
//
//  Created by Sergey V. Krupov on 30/01/2019.
//  Copyright © 2019 Home. All rights reserved.
//

import RxSwift
import UIKit

protocol RootRouterProtocol: class {

    var viewController: UIViewController? { get set }

    func presentError(_ error: Error) -> Single<Bool>
}
