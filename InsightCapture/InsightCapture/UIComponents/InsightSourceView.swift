//
//  InsightSourceView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI
import LinkPresentation

struct InsightSourceView: View {
    @State var insight: InsightData
    
    init(insight: InsightData){
        self.insight = insight
    }
    
    var body: some View {
        switch (insight.type){
        case InsightType.image.rawValue:
            ImageSourceView(insight: insight)
            
        case InsightType.url.rawValue:
            URLSourceView(insight: insight)
            
        case InsightType.quote.rawValue:
            QuoteSourceView(insight: insight)
        
        default:
            let _ = 0
        }
    }
}
