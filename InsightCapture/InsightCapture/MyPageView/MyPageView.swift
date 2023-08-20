//
//  MyPageView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI

struct MyPageView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: MyPageViewModel = MyPageViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemGray5))
                .edgesIgnoringSafeArea(.vertical)
            
            VStack {
                Spacer()
                    .frame(height: 50)
                
                List {
                    Section("나의 기록") {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 0){
                                Text("📅 ")
                                Text("영감을 함께 수집한 지 ")
                                Text(viewModel.durationDayText)
                                    .font(Font.system(size: 17, weight: .bold))
                                Text("이 되었어요.")
                            }
                            .font(Font.system(size: 15, weight: .regular))
                            
                            HStack(spacing: 0){
                                Text("🕊️ ")
                                Text("그 동안 생각, 날 것을 ")
                                Text(viewModel.runCountText)
                                    .font(Font.system(size: 17, weight: .bold))
                                Text(" 실행했어요.")
                            }
                            .font(Font.system(size: 15, weight: .regular))
                            
                            HStack(spacing: 0){
                                Text("👀 ")
                                Text("벌써 ")
                                Text(viewModel.insightCountText)
                                    .font(Font.system(size: 17, weight: .bold))
                                Text("의 영감을 기록했어요!")
                            }
                            .font(Font.system(size: 15, weight: .regular))
                            
                            HStack(spacing: 0){
                                Text("🏠 ")
                                Text("주로 영감을 얻은 곳은 ")
                                Text(viewModel.mostInsightSourceText)
                                    .font(Font.system(size: 17, weight: .bold))
                                Text("이였어요.")
                            }
                            .font(Font.system(size: 15, weight: .regular))
                        }
                        .padding(.vertical, 16)
                    }
                    .listRowSeparator(.hidden)
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    
                    Section("이용 안내") {
                        NavigationLink("공지사항을 알려드립니다") {
                            return EmptyView()
                        }
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(.black)
                        
                        NavigationLink("문의는 여기로 남겨주세요") {
                            return EmptyView()
                        }
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(.black)
                    }
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    
                    Section("바라는 점이 있나요") {
                        NavigationLink("생각, 날 것이 더 유용해지기 위해\n필요한 기능들을 제안해주세요!") {
                            return EmptyView()
                        }
                        .padding(.vertical, 10)
                        .lineSpacing(8)
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(.black)
                    }
                    .listRowSeparator(.hidden)
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    
                    Section("약관 및 정책") {
                        NavigationLink("이용 약관") {
                            return EmptyView()
                        }
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(.black)
                        
                        NavigationLink("개인정보 처리 방침") {
                            return EmptyView()
                        }
                        .font(Font.system(size: 15, weight: .regular))
                        .foregroundColor(.black)
                    }
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                }
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: UIColor.systemGray5))
                .scrollIndicators(.hidden)
            }
            
            
            HStack(spacing: 8) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(Font.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Text("내 정보")
                    .font(Font.system(size: 18, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}
