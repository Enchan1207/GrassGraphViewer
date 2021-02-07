//
//  DateFormatUtil.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/06.
//

import Foundation


extension DateFormatter {
    func getFormattedString(from: Date? = nil, format:String? = nil) -> String?{
        let targetDate = from ?? .init()
        let targetFormat = format ?? "y/M/d hh:mm:ss"
        
        self.dateFormat = targetFormat
        return self .string(from: targetDate)
    }
}
