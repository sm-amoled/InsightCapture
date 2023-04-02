//
//  InsightPageViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI

class InsightPageViewModel: ObservableObject {
    
    @Published var insight: InsightData
    @Published var offset: CGFloat
    
    let maxHeight = UIScreen.main.bounds.height / 2.6
    let topEdge: CGFloat = 15
    
    init(insight: InsightData) {
        self.insight = insight
        self.offset = 0
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return max(topHeight, 80 + topEdge)
    }
    
    func getTopBarTitleOpacity() -> CGFloat {
        let progress = -(offset + 120 ) / (maxHeight - (80 + topEdge) - 150)
        
        return progress
    }
    
    func getToolbarTitleOpacity() -> CGFloat {
        let progress = -(offset + 120) / (maxHeight - (80 + topEdge) - 100)
        return progress
    }
}
