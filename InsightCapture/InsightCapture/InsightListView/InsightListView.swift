//
//  InsightListCardView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/27.
//

import SwiftUI
import LinkPresentation

struct InsightListView: View {
    
    @StateObject var viewModel = InsightListViewModel()
    @State var boo = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(Color(uiColor: UIColor.systemGray5))
                    .edgesIgnoringSafeArea(.vertical)
                
                if viewModel.insightList.isEmpty {
                    VStack{
                        Spacer()
                        HStack{
                            Text("일상 속에서 마주치는\n반짝이는 생각들을 캐치해\n소중한 기록으로 남겨보세요")
                                .font(Font.system(size: 24, weight: .thin))
                                .lineSpacing(6)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        Spacer()
                        
                    }
                }
                
                ScrollView {
                    Spacer()
                        .frame(height: 50)
                    
                    ForEach(viewModel.insightList) { insightData in
                        InsightListCardView(viewModel: InsightListCardViewModel(insight: insightData))
                    }
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    viewModel.getInsightList()
                }
                
                ZStack {
                    HStack(spacing: 8) {
                        Text("Insight Capture")
                            .font(Font.system(size: 18, weight: .semibold))
                        
                        Spacer()
                        
                        Button {
                            viewModel.tapMyPageButton()
                        } label: {
                            Image(systemName: "person.circle")
                                .font(Font.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Button {
                            viewModel.tapAddInsightButton()
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
                .sheet(isPresented: $viewModel.isShowingAddCategorySheet) {
                    ZStack {
                        VStack(alignment: .center) {
                            // 드래그 인디케이터
                            Rectangle()
                                .frame(width: 36, height: 5)
                                .cornerRadius(5)
                                .clipped()
                                .foregroundColor(Color(uiColor: UIColor.systemGray5))
                                .padding(.vertical, 5)
                            
                            // 타이틀
                            Text("영감 기록하기")
                                .font(Font.system(size: 17, weight: .semibold))
                                .padding(.bottom, 24)
                            
                            // 카테고리 선택 버튼
                            VStack {
                                Button {
                                    viewModel.showAddInsightView()
                                } label: {
                                    InsightAddCategoryButtonLabel(iconName: "link", title: "URL 주소", description: "유튜브, 인스타그램, 웹사이트 등에서 발견한 영감")
                                }
                                
                                Button {
                                    viewModel.showAddInsightView()
                                } label: {
                                    InsightAddCategoryButtonLabel(iconName: "photo.on.rectangle.angled", title: "사진", description: "생활 속 장면에서 마주친 영감")
                                }
                                
                                Button {
                                    viewModel.showAddInsightView()
                                } label: {
                                    InsightAddCategoryButtonLabel(iconName: "quote.opening", title: "인용", description: "글과 카피 속에서 발견한 영감")
                                }
                                Button {
                                    viewModel.showAddInsightView()
                                } label: {
                                    InsightAddCategoryButtonLabel(iconName: "brain", title: "나의 생각", description: "번뜩이는 나의 영감")
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .presentationDetents([.height(375)])
                }
                .navigationDestination(isPresented: $viewModel.isShowingMyPageView) {
                    MyPageView()
                }
                .navigationDestination(isPresented: $viewModel.isShowingAddInsightView) {
                    AddInsightView()
                }
            }
        }
    }
}

struct InsightAddCategoryButtonLabel: View {
    
    let iconName: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(Color(uiColor: UIColor.systemGray5))
                Image(systemName: iconName)
                    .font(Font.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
            }
            .frame(width: 49, height: 49)
            .padding(.all, 16)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(Font.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                Text(description)
                    .font(Font.system(size: 13, weight: .regular))
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
            }
            
            Spacer()
        }
        .frame(height: 68)
    }
}
