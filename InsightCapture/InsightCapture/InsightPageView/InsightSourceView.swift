//
//  InsightSourceView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI
import LinkPresentation

struct InsightSourceView: View {
    @ObservedObject var viewModel: InsightPageViewModel
    
    @State var title: String = ""
    @State var desc: String = ""
    
    init(viewModel: InsightPageViewModel){
        self.viewModel = viewModel
        
//        if viewModel.insight.type == InsightType.url.rawValue {
//            let provider = LPMetadataProvider()
//            provider.startFetchingMetadata(for: URL(string: viewModel.insight.urlString ?? "")!) { metaData, error in
//                if error != nil { return }
//                guard let data = metaData else { return }
//
////                self.title = data.title ?? ""
//
//            }
//        }
    }
    
    var body: some View {
        switch (viewModel.insight.type){
        case InsightType.image.rawValue:
            ImageSourceView(insight: viewModel.insight)
            
        case InsightType.url.rawValue:
            URLSourceView(insight: viewModel.insight)
            
        case InsightType.quote.rawValue:
            QuoteSourceView(insight: viewModel.insight)
            
        default:
            let _ = 0
        }
    }
}
