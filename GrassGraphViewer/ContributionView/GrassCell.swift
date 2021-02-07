//
//  GrassCell.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class GrassCell: NSCollectionViewItem {
    
    var backgroundColor: NSColor?
    var borderColor: NSColor?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = self.backgroundColor?.cgColor
        self.view.layer?.borderWidth = 1
        self.view.layer?.cornerRadius = 2
        self.view.layer?.borderColor = self.borderColor?.cgColor
    }
    
    override func prepareForReuse() {
        self.backgroundColor = nil
    }
}
