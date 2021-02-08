//
//  NSColorExt.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/08.
//

import Cocoa

extension NSColor {
    // 文字コード指定して初期化
    convenience init?(hexCode: String) {
        self.init()
        
        // #を消して
        let trimmedCode = hexCode.replacingOccurrences(of: "#", with: "")
        
        // 文字数が適切なら
        if [3, 6].contains(trimmedCode.count){
            // 各色成分に分割 クソコード
            let rate = trimmedCode.count / 3
            var colorComponents: [CGFloat] = []
            for n in 0..<3 {
                // 切り出してUInt8にして
                let from = trimmedCode.index(trimmedCode.startIndex, offsetBy: n * rate)
                let to = trimmedCode.index(trimmedCode.startIndex, offsetBy: n * rate + rate)
                
                guard let colorComponent = UInt8(String(trimmedCode[from..<to]), radix: 16) else {return nil}
                
                // 0.0~1.0に変換
                colorComponents.append(CGFloat(Double(colorComponent) / 255.0))
            }
            
            // initialize
            self.init(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1)
            
        }else{
            return nil
        }
    }
}
