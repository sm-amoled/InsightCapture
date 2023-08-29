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
            PageImageSourceView()
            
        case InsightType.url.rawValue:
            PageURLSourceView()
            
        case InsightType.quote.rawValue:
            PageQuoteSourceView()
        
        default:
            let _ = 0
        }
    }
}
