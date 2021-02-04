//
//  CustomItem.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class CustomItem: NSCollectionViewItem {
    
    var backgroundColor: NSColor?
    var borderColor: NSColor?
    var contributionCount: UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    }
    
    override func viewWillAppear() {
        self.view.layer?.backgroundColor = self.backgroundColor?.cgColor
        self.view.layer?.borderWidth = 1
        self.view.layer?.cornerRadius = 2
        self.view.layer?.borderColor = self.borderColor?.cgColor
    }
    
    override func mouseDown(with event: NSEvent) {
        print(contributionCount)
    }
}
