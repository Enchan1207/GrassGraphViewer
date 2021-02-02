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
    func initWindowAppearance(window: NSWindow){
        // 背景の透明化
        window.backgroundColor = .init(white: 1, alpha: 0)
        window.isOpaque = false
        
        // ウィンドウ移動設定
        // window.isMovable = false // ウィンドウを動かさない
        window.isMovableByWindowBackground = true
        
        // その他諸々を隠す
        window.titlebarAppearsTransparent = true
        window.title = "GrassGraphViewer"
        window.titleVisibility = .hidden
        window.styleMask.remove(.titled)
        window.styleMask.remove(.closable)
        
        // ウィンドウを配置する位置を設定
        // desktopIconWindow: デスクトップとアイコンの間、ドラッグ不能
        // normalWindow: 通常アプリケーションと同様の挙動
        let windowLevel = CGWindowLevelForKey(.normalWindow)
        window.level = NSWindow.Level(rawValue: Int(windowLevel))
        
        // window.ignoresMouseEvents = true // マウスイベントを無視
        
    }
}
