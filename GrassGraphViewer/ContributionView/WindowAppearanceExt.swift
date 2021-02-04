//
//  WindowAppearanceExt.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/02.
//

import Cocoa
import Foundation

extension ContributionViewController {
    // ウィンドウ初期化
    func setWindowAppearance(window: NSWindow?, hiddenMode: Bool){
        guard let window = window else {
            return
        }
        
        // サイズ指定
        window.isRestorable = false
        window.setContentSize(self.view.frame.size)
        
        // 背景設定
        window.hasShadow = false
        window.isOpaque = false
        
        let backgroundViewColor: NSColor
        if #available(OSX 10.13, *) {
            backgroundViewColor = NSColor(named: "Background")!
        } else {
            backgroundViewColor = .init(white: 0, alpha: 0.3)
        }
        window.backgroundColor = backgroundViewColor
        
        // ウィンドウ移動設定
        window.isMovable = !hiddenMode
        
        // その他諸々を隠したり隠さなかったり
        window.titlebarAppearsTransparent = hiddenMode
        window.titleVisibility = hiddenMode ? .hidden : .visible
        window.styleMask.remove(.closable)
        if(hiddenMode){
            window.styleMask.remove(.titled)
        }else{
            window.styleMask.insert(.titled)
        }
        
        // タイトル設定
        if let username = self.currentUserName{
            window.title = "\(username)'s progress graph"
        }else{
            window.title = "progress graph"
        }

        // マウスイベントを無視
        window.ignoresMouseEvents = hiddenMode
        
        // ウィンドウ表示位置を設定
        let windowLevelKey: CGWindowLevelKey
        if(hiddenMode){
            windowLevelKey = .desktopIconWindow
        }else{
            windowLevelKey = .normalWindow
        }
        
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(windowLevelKey)))
    }
}
