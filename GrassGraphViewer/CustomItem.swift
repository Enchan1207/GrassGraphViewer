//
//  CustomItem.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class CustomItem: NSCollectionViewItem {
    
    var color: NSColor!
    var backgroundTileView: OpaqueView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        // 背景色を設定するための子ビューを追加
        backgroundTileView = OpaqueView(frame: .zero, color: color)
        view.addSubview(backgroundTileView)
    }
    
    override func viewDidLayout() {
        // frameを更新
        let tileViewFrame = NSRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        backgroundTileView?.frame = tileViewFrame
    }
    
}

class OpaqueView: NSView{
    private var backgroundColor: NSColor!
    
    init(frame frameRect: NSRect, color: NSColor) {
        super.init(frame: frameRect)
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.backgroundColor.setFill()
        dirtyRect.fill()
    }
}
