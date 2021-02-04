//
//  AppDelegate.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    // ステータスバーに置くボタン
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // ボタンに画像を設定
        if let statusBarButton = statusBarItem.button{
            statusBarButton.image = NSImage(named: "MenubarIcon")
        }
        
        // メニューボタン設定
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "環境設定", action: #selector(openPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator()) // セパレータ
        menu.addItem(NSMenuItem(title: "終了", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")) // 終了ボタン
        statusBarItem.menu = menu
        
    }
    
    // 設定画面を開く
    @objc func openPreferences(){
        // UIStoryboardからViewControllerを持ってきて
        let storyboard = NSStoryboard(name: "Preferences", bundle: nil)
        guard let initialVC = storyboard.instantiateInitialController() as? NSViewController else{
            fatalError("Couldn't generate virewController instance!")
        }
        
        // 表示
        let windowVC = NSWindowController(window: NSWindow(contentViewController: initialVC))
        windowVC.showWindow(self)
//        windowVC.close()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

