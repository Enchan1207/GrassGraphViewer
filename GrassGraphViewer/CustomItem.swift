//
//  CustomItem.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class CustomItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class CustomView: NSView{
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.gray.setFill()
        dirtyRect.fill()
    }
}
