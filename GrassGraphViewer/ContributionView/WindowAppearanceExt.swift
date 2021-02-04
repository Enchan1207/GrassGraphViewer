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
    func setWindowAppearance(window: NSWindow?, hiddenMode: Bool){
        guard let window = window else {
            return
        }
        
        // サイズ指定
        window.isRestorable = false
        window.setContentSize(self.view.frame.size)
        
        window.title = "GrassGraphViewer"
        
        // 背景設定
        window.hasShadow = false
        window.isOpaque = false
        
        let backgroundViewColor: NSColor
        if(!hiddenMode){
            if #available(OSX 10.13, *) {
                backgroundViewColor = NSColor(named: "Background")!
            } else {
                backgroundViewColor = .init(white: 0, alpha: 0.3)
            }
        }else{
            backgroundViewColor = .clear
        }
        window.backgroundColor = backgroundViewColor
        
        // ウィンドウ移動設定
        window.isMovable = !hiddenMode
        
        // その他諸々を隠したり隠さなかったり
        window.titlebarAppearsTransparent = hiddenMode
        window.titleVisibility = hiddenMode ? .hidden : .visible
        if(hiddenMode){
            window.styleMask.remove(.titled)
            window.styleMask.remove(.closable)
        }else{
            window.styleMask.insert(.titled)
            window.styleMask.insert(.closable)
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
