//
//  InsightListCardViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI
import Foundation

class InsightListViewModel: ObservableObject {
    
    @Published var insightList: [InsightData] = []
    
    @Published var isShowingAddCategorySheet: Bool = false
    @Published var isShowingMyPageView: Bool = false
    @Published var isShowingAddInsightView: Bool = false
    
    var selectedCategory: InsightType = .brain
    
    init() {
        getInsightList()
    }
    
    func getInsightList() {
        insightList = CoreDataManager.shared.getAllInsights()
    }
    
    func tapAddInsightButton() {
        isShowingAddCategorySheet = true
    }
    
    func tapMyPageButton() {
        isShowingMyPageView = true
    }
    
    func showAddInsightView(of selectedCategory: InsightType) {
        self.selectedCategory = selectedCategory
        isShowingAddCategorySheet = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isShowingAddInsightView = true
        }
    }
}
