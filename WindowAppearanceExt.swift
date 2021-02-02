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
        // 背景の透明化
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        
        // hiddenModeによって処理を分ける
        let windowLevelKey: CGWindowLevelKey
        if(hiddenMode){
            // ウィンドウ移動設定
            window.isMovable = false // ウィンドウを動かさない
            // window.isMovableByWindowBackground = true // ビューをドラッグして動かす
            
            window.titlebarAppearsTransparent = true
            window.title = "GrassGraphViewer"
            window.titleVisibility = .hidden
            window.styleMask.remove(.titled)
            window.styleMask.remove(.closable)
            
            window.ignoresMouseEvents = true // マウスイベントを無視
            
            windowLevelKey = .desktopIconWindow
        }else{
            windowLevelKey = .normalWindow
        }
        
        // ウィンドウを表示する位置を指定
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(windowLevelKey)))
    }
}
