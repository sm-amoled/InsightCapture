//
//  AddInsightViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/01.
//

import SwiftUI

class AddInsightViewModel: ObservableObject {
    
    @Published var inputTitle = ""
    @Published var inputContent = ""
    
    @Published var sourceType: InsightType = .url
    
    @Published var sourceUrl = ""
}
