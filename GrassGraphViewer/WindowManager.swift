//
//  WindowManager.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/05.
//

/// MARK:
/// **クソ実装 なんとかしろ**

import Cocoa

class WindowManager {
    private let userdefaults = UserDefaults.standard
    private let application = NSApplication.shared
    
    private let contributionViewStoryboard = NSStoryboard(name: "Contribution", bundle: nil)
    private var contributionConfigurations: [ContributionViewConfiguration] = []
    
    init() {
        // initialize
    }
    
    // 構成をもとにウィンドウを表示
    func showStoredWindows(){
        for config in contributionConfigurations{
            let window = generateContributionWindow(config: config)
            let windowController = NSWindowController(window: window)
            windowController.showWindow(self)
        }
    }
    
    // ContributionViewConfigurationからウィンドウ作成
    func generateContributionWindow(config: ContributionViewConfiguration) -> ContributionWindow{
        // VC呼び出してconfig割り当て
        guard let contributionViewController = contributionViewStoryboard.instantiateInitialController() as? ContributionViewController else{
            fatalError("Couldn't generate virewController instance!")
        }
        contributionViewController.config = config
        
        // Window生成
        let window = ContributionWindow(contentViewController: contributionViewController)
        return window
    }
    
    // UDから前回起動時のウィンドウ構成を取得
    func restoreWindowConfigurations(){
        guard let storedConfigurations = userdefaults.codable(forKey: .StoredConfigurations, type: StoredContributionViewConfigurations()) else{return}
        
        contributionConfigurations = storedConfigurations.configurations
    }
    
    // UDに現在のウィンドウ構成を保存
    func updateStoredConfiguration(){
        // アクティブなContributionWindowを持ってきて
        let activeContributionWindows = self.getActiveContributionWindows()
        
        // それぞれのViewControllerからconfigを抽出
        var configurations: [ContributionViewConfiguration] = []
        for window in activeContributionWindows {
            guard let viewController = window.contentViewController as? ContributionViewController, let config = viewController.config else {continue}
            configurations.append(config)
        }
        
        // configからStoredContributionViewConfigurationsを作って保存
        userdefaults.setStruct(StoredContributionViewConfigurations(configurations: configurations), forKey: .StoredConfigurations)
        print("Window Configuration has been saved!")
    }
    
    // NSApplicationからアクティブなContributionWindowを取得
    func getActiveContributionWindows() -> [ContributionWindow]{
        let allWindows = application.windows
        let currentActiveContributionWindows = allWindows.filter({return $0.isKind(of: ContributionWindow.self) && $0.isVisible}) as! [ContributionWindow]
        return currentActiveContributionWindows
    }
    
}
