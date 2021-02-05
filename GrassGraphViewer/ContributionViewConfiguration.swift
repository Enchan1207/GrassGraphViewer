//
//  ContributionViewConfiguration.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/04.
//

import Foundation

struct StoredContributionViewConfigurations: Codable{
    let configurations: [ContributionViewConfiguration]
    
    init(configurations: [ContributionViewConfiguration]? = nil) {
        self.configurations = configurations ?? []
    }
}

struct ContributionViewConfiguration: Codable {
    let title: String
    let userName: String
    let lastFetchDate: Date
    let presentOnLaunch: Bool
//    let theme: ContributionColorTheme
    
}

// こうするとmemberwised-initializerが残るらしい 便利
// cf. https://qiita.com/oubakiou/items/c7eba82254a810031098
extension ContributionViewConfiguration{
    init() {
        self.init(title: "", userName: "", lastFetchDate: Date(timeIntervalSince1970: 0), presentOnLaunch: false)
    }
}
