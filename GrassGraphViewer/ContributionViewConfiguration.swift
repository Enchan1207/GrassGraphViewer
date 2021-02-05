//
//  ContributionViewConfiguration.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/04.
//

import Foundation

struct StoredContributionViewConfigurations: Codable{
    let configurations: [ContributionViewConfiguration]
    
    init() {
        self.configurations = []
    }
}

struct ContributionViewConfiguration: Codable {
    let title: String
    let userName: String
    let lastFetchDate: Date
    let presentOnLaunch: Bool
//    let theme: ContributionColorTheme
}
