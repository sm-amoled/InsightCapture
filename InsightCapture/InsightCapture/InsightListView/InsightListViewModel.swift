//
//  InsightListCardViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import Foundation

class InsightListViewModel: ObservableObject {
    @Published var insightList: [InsightData] = []
    
    init() {
        getInsightList()
    }
    
    func getInsightList() {
        insightList = CoreDataManager.shared.getAllInsights()
    }
}
