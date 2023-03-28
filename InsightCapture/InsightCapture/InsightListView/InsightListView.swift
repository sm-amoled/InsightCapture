//
//  InsightListCardView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/27.
//

import SwiftUI
import LinkPresentation

struct InsightListView: View {
    
    @ObservedObject var viewModel = InsightListViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemGray5))
                .edgesIgnoringSafeArea(.vertical)
            
            ScrollView {
                Spacer()
                    .frame(height: 50)
                
                ForEach(viewModel.insightList) { insightData in
                    switch(insightData.type) {
                    case InsightType.image.rawValue:
                        InsightListImageCardView(viewModel: InsightListCardViewModel(insight: insightData))
                    case InsightType.url.rawValue:
                        InsightListURLCardView(viewModel: InsightListCardViewModel(insight: insightData))
                    case InsightType.quote.rawValue:
                        InsightListQuoteCardView(viewModel: InsightListCardViewModel(insight: insightData))
                    case InsightType.brain.rawValue:
                        InsightListBrainCardView(viewModel: InsightListCardViewModel(insight: insightData))
                    default:
                        EmptyView()
                    }
                }
            }
            .scrollIndicators(.hidden)
            
            ZStack {
                HStack(spacing: 8) {
                    Text("Insight Capture")
                        .font(Font.system(size: 18, weight: .semibold))

                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "person.circle")
                            .font(Font.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(Font.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(uiColor: UIColor.systemGray5))
        }
    }
}
