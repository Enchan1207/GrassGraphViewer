//
//  WindowManager.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/05.
//

import Cocoa

class WindowManager {
    private let userdefaults = UserDefaults.standard
    private let application = NSApplication.shared
    private var windows: [ContributionWindow] = []
    
    private var contributionConfigurations: [ContributionViewConfiguration] = []
    
    init() {
        // UDから構成をリストア
        restoreWindowConfigurations()
        
    }
    
    // UDから前回起動時のウィンドウ構成を取得
    func restoreWindowConfigurations(){
        guard let storedConfigurations = userdefaults.codable(forKey: .StoredConfigurations, type: StoredContributionViewConfigurations()) else{return}
        
        contributionConfigurations = storedConfigurations.configurations
    }
    
    // UDに現在の構成を保存
    func updateStoredConfiguration(){
        
    }
    
    // アクティブなContributionViewcontrollerを取得
    func getActiveContributionViewControllers() -> [ContributionWindow]{
        let allWindows = application.windows
        let currentActiveContributionWindows = allWindows.filter({return $0.isKind(of: ContributionWindow.self) && $0.isVisible}) as! [ContributionWindow]
        return currentActiveContributionWindows
    }
    
}
