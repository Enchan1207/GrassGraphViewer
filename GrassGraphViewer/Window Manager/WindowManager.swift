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
    
    private let contributionViewStoryboard = NSStoryboard(name: "Contribution", bundle: nil)
    private var configurations: [ContributionConfig] = []
    
    init() {
        // initialize
    }
    
    // 構成をもとにウィンドウを生成し、表示
    func showStoredWindows(){
        for config in configurations{
            let window = generateContributionWindow(config: config, displayMode: .Background)
            let windowController = NSWindowController(window: window)
            windowController.showWindow(self)
        }
    }
    
    // ContributionConfigからウィンドウを作る
    func generateContributionWindow(config: ContributionConfig, displayMode: ContributionWindow.DisplayMode) -> ContributionWindow{
        // VC呼び出してconfig割り当て
        guard let contributionViewController = contributionViewStoryboard.instantiateInitialController() as? ContributionViewController else{
            fatalError("Couldn't generate virewController instance!")
        }
        contributionViewController.config = config
        
        // Window生成
        let window = ContributionWindow(contentViewController: contributionViewController, displayMode: displayMode)
        return window
    }
    
    // UDから前回起動時のウィンドウ構成を取得
    func restoreWindowConfigurations(){
        guard let storedConfigurations = userdefaults.codable(forKey: .StoredConfigurations, type: ContributionConfigurations()) else{return}
        configurations = storedConfigurations.configs
    }
    
    // UDに現在のウィンドウ構成を保存
    func updateStoredConfiguration(){
        // アクティブなContributionWindowを持ってきて
        let activeContributionWindows = self.getActiveContributionWindows()
        
        // それぞれのViewControllerからconfigを抽出
        var configurations: [ContributionConfig] = []
        for window in activeContributionWindows {
            guard let viewController = window.contentViewController as? ContributionViewController, let config = viewController.config else {continue}
            configurations.append(config)
        }
        
        // 保存
        userdefaults.setStruct(ContributionConfigurations(configurations), forKey: .StoredConfigurations)
    }
    
    // NSApplicationからアクティブなContributionWindowを取得
    func getActiveContributionWindows() -> [ContributionWindow]{
        let allWindows = application.windows
        let currentActiveContributionWindows = allWindows.filter({return $0.isKind(of: ContributionWindow.self) && $0.isVisible}) as! [ContributionWindow]
        return currentActiveContributionWindows
    }
    
    // ContributionConfigをまとめて管理するだけの構造体 こういうのってどう実装すればいいんですかね?
    private struct ContributionConfigurations: Codable{
        let configs: [ContributionConfig]
        init(_ configs: [ContributionConfig]? = nil){
            self.configs = configs ?? []
        }
    }
    
}
