//
//  WindowAppearanceExt.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/02.
//

import Cocoa
import Foundation

extension ViewController {
    // ウィンドウ初期化
    func setWindowAppearance(window: NSWindow, hiddenMode: Bool){
        // サイズ指定
        window.isRestorable = false
        window.setFrame(NSRect(origin: window.frame.origin, size: self.view.frame.size), display: true)
        
        // 背景の透明化
        window.backgroundColor = .init(white: 0, alpha: 0)
        window.hasShadow = false
        window.isOpaque = false
        
        let windowLevelKey: CGWindowLevelKey
        if(hiddenMode){
            // ウィンドウ移動設定
            window.isMovable = false // ウィンドウを動かさない
            // window.isMovableByWindowBackground = true // viewをドラッグして移動

            // その他諸々を隠す
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask.remove(.titled)
            window.styleMask.remove(.closable)

            window.ignoresMouseEvents = true // マウスイベントを無視

            windowLevelKey = .desktopIconWindow
        }else{
            window.title = "GrassGraphViewer"
            windowLevelKey = .normalWindow
        }
        
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(windowLevelKey)))
    }
}
