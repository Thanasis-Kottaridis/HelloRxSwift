//
//  Weather.swift
//  HelloRxSwift
//
//  Created by thanos kottaridis on 31/8/21.
//

import Foundation

struct WeatherResults: Codable {
    var main: Weather?
}

struct Weather: Codable {
    var temp: Double?
    var humidity: Double?
}
