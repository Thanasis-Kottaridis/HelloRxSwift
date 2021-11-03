//
//  URLRequest+Extensions.swift
//  HelloRxSwift
//
//  Created by thanos kottaridis on 31/8/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T: Codable> {
    let url: URL
}

extension URLRequest {
    static func load<T: Codable>(resource: Resource<T>) -> Observable<T> {
        return Observable.just(resource.url).flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
        }.map({ data -> T in
            return try JSONDecoder().decode(T.self, from: data)
        }).asObservable()
    }
}
