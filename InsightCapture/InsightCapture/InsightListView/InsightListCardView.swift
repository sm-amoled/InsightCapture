//
//  InsightListCardViews.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI
import LinkPresentation

struct InsightListCardView: View {
    @StateObject var viewModel: InsightListCardViewModel
    
    var body: some View {
        if viewModel.insight.title != nil {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: .init(uiColor: UIColor(white: 0, alpha: 0.25)), radius: 4, x: 0, y: 1)
                
                VStack {
                    HStack {
                        Text(viewModel.insight.createdDate!.toCardDateString())
                            .font(Font.system(size: 13, weight: .medium))
                        
                        Spacer()
                        Button {
                            // 더 보기 액션 구현하기
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(Font.system(size: 13, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    .padding(.bottom, 6)
                    
                    VStack(alignment: .leading) {
                        switch(viewModel.insight.type) {
                        case InsightType.image.rawValue:
                            CardImageSourceView(insight: viewModel.insight)
                            
                        case InsightType.url.rawValue:
                            CardURLSourceView(insight: viewModel.insight)
                            
                        case InsightType.quote.rawValue:
                            CardQuoteSourceView(insight: viewModel.insight)
                            
                        case InsightType.brain.rawValue:
                            EmptyView()
                            
                        default:
                            EmptyView()
                        }
                        
                        Text(viewModel.insight.title!)
                            .font(Font.system(size: 16, weight: .semibold))
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 4)
                            .padding(.top, 8)
                        
                        Text(viewModel.insight.content!)
                            .font(Font.system(size: 16, weight: .regular))
                            .lineLimit(3)
                            .padding(.horizontal, 12)
                            .padding(.bottom, 16)
                        
                        HStack {
                            Spacer()
                            Text("자세히 보기")
                                .font(Font.system(size: 13, weight: .light))
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 16)
                    }
                }
            }
            .padding(.horizontal, 16)
            .navigationDestination(isPresented: $viewModel.isShowingInsightPageView, destination: {
                InsightPageView(viewModel: InsightPageViewModel(insight: viewModel.insight))
            })
            .onTapGesture {
                viewModel.tapCard()
            }
        }
    }
}
