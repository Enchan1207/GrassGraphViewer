//
//  ContributionWindow.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/05.
//

import Cocoa

class ContributionWindow: NSWindow{
    
    // 透明ウィンドウをよしなに作ってくれる
    init(contentViewController: ContributionViewController){
        let contentRect = contentViewController.view.frame
        let styleMask: NSWindow.StyleMask = [.titled, .resizable, .borderless]
        let backingType: NSWindow.BackingStoreType = .buffered
        
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backingType, defer: false)
        
        // ウィンドウ表示モードに依存しない設定はここでやっちゃう
        self.contentViewController = contentViewController
        let userName = contentViewController.config?.userName ?? "Unknown"
        self.title = "\(userName)'s Contribution Graph"
        self.tabbingMode = .disallowed
        self.isRestorable = false
        self.hasShadow = false
        self.isOpaque = false
        self.styleMask.remove(.closable)
        
        let backgroundViewColor: NSColor
        if #available(OSX 10.13, *) {
            backgroundViewColor = NSColor(named: "Background")!
        } else {
            backgroundViewColor = .init(white: 0, alpha: 0.3)
        }
        self.backgroundColor = backgroundViewColor
    }
    
    convenience init(contentViewController: ContributionViewController, displayMode: DisplayMode) {
        self.init(contentViewController: contentViewController)
        self.setDisplayMode(displayMode)
    }
    
    // ウィンドウ表示モードの切り替え
    func setDisplayMode(_ mode: DisplayMode){
        let isHiddenMode = mode == .Background
        
        self.isMovable = !isHiddenMode
        self.titlebarAppearsTransparent = isHiddenMode
        self.titleVisibility = isHiddenMode ? .hidden : .visible
        if(isHiddenMode){
            self.styleMask.remove(.titled)
        }else{
            self.styleMask.insert(.titled)
        }
        self.ignoresMouseEvents = isHiddenMode
        
        // ウィンドウ表示位置設定
        let windowLevelKey: CGWindowLevelKey
        if(isHiddenMode){
            windowLevelKey = .desktopIconWindow
        }else{
            windowLevelKey = .normalWindow
        }
        
        self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(windowLevelKey)))
    }
    
    // ウィンドウ表示モード
    enum DisplayMode{
        case Foreground // 通常ウィンドウと同様
        case Background // 背景に配置、マウスイベント無視
    }

}
