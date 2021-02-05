//
//  ContributionWindow.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/05.
//

import Cocoa

class ContributionWindow: NSWindow{
    // 強制的に新規ウィンドウで開く
    override var tabbingMode: NSWindow.TabbingMode{
        get{
            return .disallowed
        }
        set{}
    }
}
