//
//  Date+.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import Foundation

extension Date {
    public func createCardDateString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        formatter.calendar?.locale = Locale(identifier: "en_US")
        
        let timeGap = Date().timeIntervalSince(self)
        let largestUnitOfGap = formatter.string(from: timeGap) ?? ""
        
        let timeUnit = largestUnitOfGap.last ?? Character(" ")
        var timeValue = largestUnitOfGap
        
        timeValue.removeLast()
        
        var result: String = ""
        
        switch(timeUnit) {
        case "d":
            if Int(timeValue)! <= 28 {
                result.append(timeValue)
                result.append("일 전")
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                result.append(dateFormatter.string(from: self))
            }
        case "h":
            result.append(timeValue)
            result.append("시간 전")
        case "m":
            result.append(timeValue)
            result.append("분 전")
        case "s":
            result.append("방금 전")
        default:
            print("yyyy-mm-dd")
        }
        
        return result
    }
}
