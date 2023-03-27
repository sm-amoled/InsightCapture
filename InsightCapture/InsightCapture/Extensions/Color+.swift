//
//  Color+.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/27.
//

import SwiftUI

extension Color {
    static func randomColor(from date: Date) -> Color {
        let calendar = NSCalendar.current
        
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let dayRatio = Double(day)/31
        let hourRatio = Double(hour)/24
        let minuteRatio = Double(minute)/60
        
        // 세 값중 가장 작은 값이면 166, 가장 큰 값이면 187, 중간 값이면 166~187의 값을 가진다.
        let red = dayRatio == max(dayRatio, hourRatio, minuteRatio) ? 187/256 : dayRatio == min(dayRatio, hourRatio, minuteRatio) ? 166/256 : (166 + 21 * dayRatio) / 256
        let green = hourRatio == max(dayRatio, hourRatio, minuteRatio) ? 187/256 : hourRatio == min(dayRatio, hourRatio, minuteRatio) ? 166/256 : (166 + 21 * hourRatio) / 256
        let blue = minuteRatio == max(dayRatio, hourRatio, minuteRatio) ? 187/256 : minuteRatio == min(dayRatio, hourRatio, minuteRatio) ? 166/256 : (166 + 21 * minuteRatio) / 256
        
        return Color(red: red, green: green, blue: blue)
    }
}
