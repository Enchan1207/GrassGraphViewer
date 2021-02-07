//
//  DateFormatUtilTests.swift
//  GrassGraphViewerTests
//
//  Created by EnchantCode on 2021/02/06.
//


import XCTest
@testable import GrassGraphViewer

class DateFormatUtilTests: XCTestCase {
    
    override func tearDownWithError() throws {
        //
    }
    
    override func setUpWithError() throws {
        //
    }
    
    func testPrintFormattedDateString() throws {
        print("DateFormatter localized String")
        print(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium))
    }
   
}
