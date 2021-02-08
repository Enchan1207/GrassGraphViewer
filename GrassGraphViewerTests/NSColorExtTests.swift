//
//  NSColorExtTests.swift
//  GrassGraphViewerTests
//
//  Created by EnchantCode on 2021/02/08.
//

import XCTest
@testable import GrassGraphViewer

class NSColorExtTests: XCTestCase {
    
    // カラーコードからNSColorを生成
    func testInitializeNSColorFromHexCode() throws {
        /// NOTE **これ256, 256, 256にするとテストケース終わらなくなるのでやっちゃダメです** (多分いつか終わるんだろうけどこのソースでやるもんじゃねえ)
        for red in 0..<2 {
            for green in 0..<2 {
                for blue in 0..<256 {
                    // 各色成分を16進変換してカラーコード生成
                    let colorCode = String(format: "#%02X%02X%02X", red, green, blue)
                    
                    // NSColorを生成し色成分に分割
                    let color = NSColor(hexCode: colorCode)
                    XCTAssertNotNil(color)
                    let parsedRedComponent = UInt8(color!.redComponent * 255.0)
                    let parsedGreenComponent = UInt8(color!.greenComponent * 255.0)
                    let parsedBlueComponent = UInt8(color!.blueComponent * 255.0)
                    
                    // 値が一致するか確かめる
                    XCTAssertTrue(red == parsedRedComponent)
                    XCTAssertTrue(green == parsedGreenComponent)
                    XCTAssertTrue(blue == parsedBlueComponent)
                }
            }
        }
    }
    
}
