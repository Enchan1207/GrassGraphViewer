//
//  ContributionViewConfiguration.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/04.
//

import Foundation

struct ContributionConfig: Codable {
    let userName: String
    var lastFetchDate: Date
    var contributions: [ContributionInfo]
}
