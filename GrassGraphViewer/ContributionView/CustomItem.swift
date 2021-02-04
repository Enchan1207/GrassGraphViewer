//
//  CustomItem.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class CustomItem: NSCollectionViewItem {
    
    private var backgroundColor: NSColor?
    private var borderColor: NSColor?

    var contribution: ContributionInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        
        // 色指定
        if #available(OSX 10.13, *) {
            let itemColorName = "GrassColor/Level\(contribution.level)"
            self.backgroundColor = NSColor(named: itemColorName)
            self.borderColor = NSColor(named: "GrassColor/Border")
        } else {
            // TODO: 対応してなければHSBでそれっぽいのを作る
            self.backgroundColor = .green
            self.borderColor = .systemGray
        }
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = self.backgroundColor?.cgColor
        self.view.layer?.borderWidth = 1
        self.view.layer?.cornerRadius = 2
        self.view.layer?.borderColor = self.borderColor?.cgColor
    }
    
    override func mouseDown(with event: NSEvent) {
        print(contribution.contributionCount)
    }
    
    override func prepareForReuse() {
        self.backgroundColor = nil
    }
}
