//
//  ViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // コントリビューションの状態を取得
        let dataURLString = "https://github.com/users/Enchan1207/contributions"
        guard let contributionData = try? Data(contentsOf: URL(string: dataURLString)!) else {
            fatalError("Oh, no!")
        }
        print(String(data: contributionData, encoding: .utf8))

        // XMLParser...
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

