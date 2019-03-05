//
//  Result.swift
//  Weather
//
//  Created by Sergey V. Krupov on 05.03.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

enum Result<T> {
    case success(T)
    case failure(Error)

    var value: T? {
        if case let .success(value) = self {
            return value
        }
        return nil
    }
}
