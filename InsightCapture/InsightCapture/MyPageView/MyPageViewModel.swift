//
//  MyPageViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/20.
//

import SwiftUI

class MyPageViewModel: ObservableObject {
    @Published var durationDayText: String = "1일"
    @Published var runCountText: String = "1번"
    @Published var insightCountText: String = "1개"
    @Published var mostInsightSourceText: String = ""
    
    init() {
        setMyHistory()
    }
    
    func setMyHistory() {
        setDurationDayText()
        setRunCountText()
        setInsightCountText()
        setMostInsightSourceText()
    }
    
    func setDurationDayText() {
        let distance = InsightHistoryManager.shared.firstDayDistance
        
        if distance?.year ?? 0 >= 1 {
            if distance?.month ?? 0 >= 1 {
                durationDayText = "\(distance!.year ?? 0)년 \(distance!.month ?? 0)개월"
            } else {
                durationDayText = "\(distance!.year ?? 0)년"
            }
        } else if distance?.month ?? 0 >= 1 {
            durationDayText = "\(distance!.month ?? 0)개월"
        } else {
            durationDayText = "\((distance?.day ?? 1) + 1)일"
        }
    }
    
    func setRunCountText() {
        runCountText = "\(InsightHistoryManager.shared.runCount ?? 0)번"
    }
    
    func setInsightCountText() {
        insightCountText = "\( InsightHistoryManager.shared.insightCount ?? 0)번"
    }
    
    func setMostInsightSourceText() {
        mostInsightSourceText = "\(InsightHistoryManager.shared.getMostInsightSource())"
    }
}
