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
    private let windowManager = WindowManager()
    private var preferencesWindowController: NSWindowController!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // ステータスバーボタン初期化
        initStatusBarButton()
        
        // StoryboardからPreferencesViewControllerを持ってきておく
        initPreferencesViewController()
        
        // ウィンドウマネージャから構成を復元してウィンドウ表示
        windowManager.restoreWindowConfigurations()
        windowManager.showStoredWindows()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // 環境設定ビューを用意
    func initPreferencesViewController(){
        let preferencesStoryboard = NSStoryboard(name: "Preferences", bundle: nil)
        guard let preferencesViewcontroller = preferencesStoryboard.instantiateInitialController() as? NSSplitViewController else{
            fatalError("Couldn't generate virewController instance!")
        }
        self.preferencesWindowController = NSWindowController(window: NSWindow(contentViewController: preferencesViewcontroller))
    }
    
}

// メニューバーアイコン
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
        preferencesWindowController.window?.orderFrontRegardless()
    }
    
    // 「UserDefaultsを初期化して終了」
    @objc func initUserDefaults(){
        let userdefaults = UserDefaults.standard
        _ = UserDefaultsKey.allCases.map({
            userdefaults.removeObject(forKey: $0.rawValue)
        })
        NSApplication.shared.terminate(nil)
    }
}
