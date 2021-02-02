//
//  ViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/01.
//

import Cocoa
import CoreImage
import CoreGraphics

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画像ビュー配置
        let imageURLString = "https://enchan-lab.net/Storage/icon.jpg"
        guard let image = NSImage(contentsOf: URL(string: imageURLString)!) else{
            fatalError("Can't load image from file!")
        }
        let imageView = CustomImageView(image: image)
        imageView.frame = NSRect(x: 0, y: 0, width: 400, height: 300)
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = .black
        self.view.addSubview(imageView)
    }
    
    override func viewWillAppear() {
        // ウィンドウ初期化
        if let window = self.view.window{
            initWindowAppearance(window: window)
        }else{
            assertionFailure("Window object is nil!")
        }
        
        // ウィンドウ枠を設定
        self.view.wantsLayer = true
        self.view.layer?.cornerRadius = 10
        self.view.layer?.borderWidth = 5
        self.view.layer?.borderColor = .init(gray: 0.2, alpha: 1)
    }
    
    override func viewDidAppear() {
    }
    
}

class CustomView: NSView {
    // y軸を入れ替える
    override var isFlipped: Bool{
        get{
            return true;
        }
    }
    // CGで描画する場合は必須
    // CGContextTranslateCTM(layerContext, 0, layerHeight );
    // CGContextScaleCTM(layerContext, 1, -1);
}

class CustomImageView: NSImageView {
    // マウスクリックで移動できるように
    override var mouseDownCanMoveWindow: Bool{
        get{
            return true
        }
    }
}
