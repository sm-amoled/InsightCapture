//
//  InsightPageViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import Foundation

class InsightPageViewModel: ObservableObject {
    
    @Published var insight: InsightData
    @Published var offset: CGFloat {
        didSet {
            print(self.offset)
        }
    }
    
    init(insight: InsightData) {
        self.insight = insight
        self.offset = 0
    }
}
