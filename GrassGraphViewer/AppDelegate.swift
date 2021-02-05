//
//  AppDelegate.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    let application = NSApplication.shared
    let userdefaults = UserDefaults.standard
    
    private var contributionConfigurations: [ContributionViewConfiguration] = []
    private var preferencesWindowController: NSWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // ステータスバーボタン初期化
        initStatusBarButton()
        
        // StoryboardからPreferencesViewControllerを持ってきておく
        initPreferencesViewController()
        
        // 前回のウィンドウ構成をリストアして
        let windowConfigurations: [ContributionViewConfiguration]
        if let storedConfigurations = userdefaults.codable(forKey: .StoredConfigurations, type: StoredContributionViewConfigurations()){
            windowConfigurations = storedConfigurations.configurations
        }else{
            windowConfigurations = []
        }
        
        // ウィンドウを構成
        for configuration in windowConfigurations{
            
            
        }
        
        let contributionViewStoryboard = NSStoryboard(name: "Contribution", bundle: nil)

        // 各ウィジェットごとにNSWindowを作って表示する
        // TODO: ウィンドウ増やしたり減らしたりする時どうすんの?
        for config in contributionConfigurations {
            // VCを呼び出して
            guard let contributionViewController = contributionViewStoryboard.instantiateInitialController() as? ContributionViewController else{
                fatalError("Couldn't generate virewController instance!")
            }
            
            // コンフィグ渡して
            contributionViewController.config = config
            
            // NSWindow作って表示
            let window = ContributionWindow(contentViewController: contributionViewController)
            window.tabbingMode = .disallowed
            let windowController = NSWindowController(window: window)
            windowController.showWindow(self)
        }
    }
    
    // 環境設定ビューを用意
    func initPreferencesViewController(){
        let preferencesStoryboard = NSStoryboard(name: "Preferences", bundle: nil)
        guard let preferencesViewcontroller = preferencesStoryboard.instantiateInitialController() as? PreferencesViewController else{
            fatalError("Couldn't generate virewController instance!")
        }
        preferencesViewcontroller.isVisible = true
        self.preferencesWindowController = NSWindowController(window: NSWindow(contentViewController: preferencesViewcontroller))
    }


    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

// メニューバーアイコン項目
extension AppDelegate{
    // ステータスバーボタン初期化
    func initStatusBarButton(){
        if let statusBarButton = statusBarItem.button{
            statusBarButton.image = NSImage(named: "MenubarIcon")
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "環境設定", action: #selector(openPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Userdefaultsを初期化して終了", action: #selector(initUserDefaults), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "終了", action: #selector(NSApplication.shared.terminate(_:)), keyEquivalent: "q"))
        statusBarItem.menu = menu
    }
    
    // 「環境設定」
    @objc func openPreferences(){
        preferencesWindowController.showWindow(self)
        preferencesWindowController.window?.orderFront(self)
    }
    
    // 「UserDefaultsを初期化して終了」
    @objc func initUserDefaults(){
        _ = UserDefaultsKey.allCases.map({
            userdefaults.removeObject(forKey: $0.rawValue)
        })
        NSApplication.shared.terminate(nil)
    }
}
