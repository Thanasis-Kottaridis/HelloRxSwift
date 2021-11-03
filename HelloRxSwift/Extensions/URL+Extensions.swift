//
//  URL+Extensions.swift
//  HelloRxSwift
//
//  Created by thanos kottaridis on 31/8/21.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=ab8fe181c436403e2761afd68d4902ad&units=metric")
    }
}
