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
                        ZStack {
                            if viewModel.insight.image == nil {
                                // 이미지가 없는 경우
                            } else {
                                Image(uiImage: UIImage(data: viewModel.insight.image!)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.size.width - 32 - 16, height: (UIScreen.main.bounds.size.width - 32 - 16) * 0.56)
                                    .cornerRadius(8)
                                    .clipped()
                            }
                        }
                        .padding(.horizontal, 8)
                        
                    case InsightType.url.rawValue:
                        ZStack {
                            HStack {
                                if viewModel.urlImage != nil {
                                    Image(uiImage: viewModel.urlImage!)
                                        .resizable()
                                        .frame(width: 136, height: 76)
                                        .clipped()
                                } else {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 136, height: 76)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.urlTitle ?? "")
                                        .font(Font.system(size: 15, weight: .bold))
                                        .lineLimit(2)
                                        .padding(.vertical, 2)
                                    
                                    Text(viewModel.urlDescription ?? "")
                                        .font(Font.system(size: 12, weight: .light))
                                        .lineLimit(1)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 3)
                            }
                            .padding(.all, 8)
                            .background(Color(uiColor: UIColor.systemGray5))
                            .cornerRadius(10)
                            
                            if viewModel.urlImage == nil {
                                ProgressView()
                            }
                        }
                        .padding(.horizontal, 8)
                        
                    case InsightType.quote.rawValue:
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.randomColor(from: viewModel.insight.createdDate ?? Date()))
                                .padding(.horizontal, 50)
                                .padding(.vertical, 8)
                            
                            VStack {
                                Image(systemName: "quote.opening")
                                    .padding(.top, 8)
                                
                                Text(viewModel.insight.quote ?? "")
                                    .font(Font.system(size: 16, weight: .medium))
                                    .lineLimit(3)
                                    .padding(.top, 8)
                                    .padding(.bottom, 16)
                                
                                HStack {
                                    Spacer()
                                }
                            }
                            .padding(.all, 8)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 8)
                        
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
                    
                    Text(viewModel.insight.text!)
                        .font(Font.system(size: 16, weight: .medium))
                        .lineLimit(3)
                        .padding(.horizontal, 12)
                        .padding(.bottom, 16)
                    
                    HStack {
                        Spacer()
                        Text("자세히 보기")
                            .font(Font.system(size: 13, weight: .medium))
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
                }
                .onTapGesture {
                    viewModel.tapCard()
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowingInsightPageView, destination: {
                InsightPageView(viewModel: InsightPageViewModel(insight: viewModel.insight))
                
            })
            .background {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: .init(uiColor: UIColor(white: 0, alpha: 0.25)), radius: 4, x: 0, y: 1)
            }
            .padding(.horizontal, 16)
        }
    }
}
