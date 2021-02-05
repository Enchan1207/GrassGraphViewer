//
//  PreferencesCutsomView.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/05.
//

import Cocoa

@IBDesignable class PreferencesCustomView: NSView{
    @IBInspectable var backgroundColor: NSColor = .clear
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: NSColor = .clear
    
    override var wantsLayer: Bool {
        get{return true}
        set{}
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.layer?.backgroundColor = self.backgroundColor.cgColor
        self.layer?.borderWidth = self.borderWidth
        self.layer?.borderColor = self.borderColor.cgColor
    }
}
