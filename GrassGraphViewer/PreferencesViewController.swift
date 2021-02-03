//
//  PreferencesViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/03.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    let appDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        print("Ohhhh Fuck!!")
        
        // 他のウィンドウにアクセスできないもんかね
        NotificationCenter.default.post(name: .kPreferenceUpdatedNotification, object: CGWindowLevelKey.desktopIconWindow.rawValue)
        
    }
    
}
