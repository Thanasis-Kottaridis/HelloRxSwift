//
//  Articles.swift
//  HelloRxSwift
//
//  Created by thanos kottaridis on 31/8/21.
//

import Foundation

struct ArticlesList: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}

struct Article: Codable {
    let title: String?
    let description: String?
}
