//
//  ContributionViewConfiguration.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/04.
//

import Cocoa

struct ContributionConfig: Codable {
    let userName: String
    var lastFetchDate: Date
    var contributions: [ContributionInfo]
}

struct WindowConfig: Codable {
    let contentRect: NSRect
    let windowIdentifier: String
    
    var contributionConfig: ContributionConfig
}
