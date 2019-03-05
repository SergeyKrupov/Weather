//
//  NetworkService.swift
//  Weather
//
//  Created by Sergey V. Krupov on 28.01.2019.
//  Copyright © 2019 Sergey V. Krupov. All rights reserved.
//

import Alamofire
import RxCocoa
import RxSwift

protocol NetworkService {

    func request(_ url: URL) -> Single<Data>

    func jsonRequest<T: Decodable>(url: URL, parameters: [String: Any]) -> Single<T>
}

final class NetworkComponent: NetworkService {

    enum Error: Swift.Error {
        case undefinedNetworkError
    }

    func request(_ url: URL) -> Single<Data> {
        let request = URLRequest(url: url)
        return URLSession.shared.rx.data(request: request).asSingle()
    }

    func jsonRequest<T: Decodable>(url: URL, parameters: [String: Any]) -> Single<T> {
        return Single.create { singleAction -> Disposable in
            let request = Alamofire.request(url, method: .get, parameters: parameters)

            request.responseData { response in
                guard let data = response.data else {
                    let error: Swift.Error = response.error ?? Error.undefinedNetworkError
                    singleAction(.error(error))
                    return
                }

                do {
                    let payload = try JSONDecoder().decode(T.self, from: data)
                    singleAction(.success(payload))
                } catch {
                    singleAction(.error(error))
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }
}
