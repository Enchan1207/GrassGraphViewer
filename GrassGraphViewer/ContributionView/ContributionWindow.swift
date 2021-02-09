//
//  ContributionWindow.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/05.
//

import Cocoa

class ContributionWindow: NSWindow{
    
    public let windowIdentifier: String
    
    // 透明ウィンドウをよしなに作ってくれる
    init(contentViewController: ContributionViewController, identifier: String? = nil){
        let contentRect = contentViewController.view.frame
        let styleMask: NSWindow.StyleMask = [.titled, .resizable, .borderless]
        let backingType: NSWindow.BackingStoreType = .buffered
        self.windowIdentifier = identifier ?? NSUUID().uuidString
        
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backingType, defer: false)
        
        // ウィンドウ表示モードに依存しない設定はここでやっちゃう
        self.isMovableByWindowBackground = true
        self.contentViewController = contentViewController
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
    
    // displaymode渡してもよき(UDからデータ引っ張ってきた時用)
    convenience init(contentViewController: ContributionViewController, identifier: String? = nil, displayMode: DisplayMode) {
        self.init(contentViewController: contentViewController, identifier: identifier)
        self.setDisplayMode(displayMode)
    }
    
    // このウィンドウが持つVCのConfigを取得
    func getContributionConfig() -> ContributionConfig? {
        guard let contributionViewController = self.contentViewController as? ContributionViewController else { return nil }
        return contributionViewController.config
    }
    
    // ウィンドウ表示モードの切り替え
    func setDisplayMode(_ mode: DisplayMode){
        let isHiddenMode = mode == .Background
        
        self.isMovable = !isHiddenMode
        self.titlebarAppearsTransparent = isHiddenMode
        self.titleVisibility = isHiddenMode ? .hidden : .visible
        self.styleMask.remove(.titled)
        self.ignoresMouseEvents = isHiddenMode
        
        // ウィンドウ表示位置(z軸)設定
        let windowLevelKey: CGWindowLevelKey = isHiddenMode ? .desktopIconWindow : .normalWindow
        self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(windowLevelKey)))
    }
    
    // ウィンドウ表示モード
    enum DisplayMode{
        case Foreground // 通常ウィンドウと同様
        case Background // 背景に配置、マウスイベント無視
    }

}
