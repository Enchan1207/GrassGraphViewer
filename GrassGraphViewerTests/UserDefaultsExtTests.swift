//
//  UserDefaultsExtTests.swift - UserDefaults拡張ユニットテスト
//  GrassGraphViewerTests
//
//  Created by EnchantCode on 2021/02/05.
//

import XCTest
@testable import GrassGraphViewer

class UserDefaultsExtTests: XCTestCase {
    
    private let userdefaults = UserDefaults.standard
    private let keyPrefix = "net.enchan-lab.UserDefaultsExtTests"
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    // Date型拡張テスト
    func testStoreDate() throws {
        let dateObjectKey = "\(keyPrefix).testStoreDateObject"
        let sampleDate = Date(timeIntervalSince1970: 1000)
        
        userdefaults.setValue(sampleDate, forKey: dateObjectKey)
        let storedDate = userdefaults.date(forKey: dateObjectKey)
        
        XCTAssertTrue(sampleDate == storedDate)
    }
    
    // struct拡張テスト
    func testStoreStruct() throws {
        struct SampleStruct: Codable, Equatable{
            let name: String
            let id: Int
            let birthday: Date
            let high: Double
            let weight: Float
            let isAlive: Bool
        }
        
        let sampleStructKey = "\(keyPrefix).testStoreStruct"
        let sampleStruct = SampleStruct(name: "User", id: 123456, birthday: Date(), high: 170.5, weight: 54.3, isAlive: true)
        
        userdefaults.setStruct(sampleStruct, forKey: sampleStructKey)
        
        guard let storedStruct = userdefaults.codable(forKey: sampleStructKey, type: sampleStruct) else {
            fatalError("Couldn't decode!")
        }
        
        XCTAssertTrue(sampleStruct == storedStruct)
    }
}
