//
//  InsightPageView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI

struct InsightPageView: View {
    @StateObject var viewModel: InsightPageViewModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack{
                ZStack {
                    Color.randomColor(from: viewModel.insight.createdDate ?? Date())
                    
                    if viewModel.image != nil {
                        Image(uiImage: viewModel.image!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: viewModel.getHeaderHeight())
                
                Spacer()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    GeometryReader { proxy in
                        TopBar(maxHeight: viewModel.maxHeight, offset: $viewModel.offset, viewModel: viewModel)
                            .frame(maxWidth: .infinity)
                            .frame(height: viewModel.getHeaderHeight(), alignment: .bottom)
                    }
                    .frame(height: viewModel.maxHeight)
                    .offset(y: -viewModel.offset)
                    .zIndex(2)
                    
                    VStack {
                        VStack(spacing: 24) {
                            // 날짜
                            Text(viewModel.insight.createdDate?.toPageDateString() ?? "")
                                .font(Font.system(size: 13, weight: .medium))
                            
                            // 본문 컨텐츠
                            Text(viewModel.insight.content ?? "")
                                .multilineTextAlignment(.center)
                                .font(Font.system(size: 16, weight: .medium))
                            
                            // 인사이트 source
                            InsightSourceView(insight: viewModel.insight)
                            
                            // 하단 여백
                            Spacer()
                                .frame(height: 100)
                        }
                        .padding(.horizontal, 16)
                    }
                    .zIndex(1)
                    .background {
                        ZStack{
                            VStack {
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .offset(y:-20)
                            Color.white
                        }
                    }
                }
                .modifier(OffsetModifier(offset: $viewModel.offset))
            }
        }
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(Font.system(size: 16, weight: .medium))
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(viewModel.insight.title ?? "")
                    .lineLimit(1)
                    .font(Font.system(size: 16, weight: .medium))
                    .opacity(viewModel.getToolbarTitleOpacity() )
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.isShowingActions = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .font(Font.system(size: 16, weight: .medium))
                }
            }
        }
        .toolbarBackground(Color.white, for: .navigationBar)
        .confirmationDialog("인사이트", isPresented: $viewModel.isShowingActions, titleVisibility: .hidden) {
            Button("수정하기", action: {
                
            })
            Button("삭제하기", role: .destructive, action: {
                viewModel.deleteInsight()
                dismiss()
            })
        }
    }
}

struct TopBar: View {
    let topBarHeight: CGFloat = 120
    var maxHeight: CGFloat
    var topEdge: CGFloat = 15
    
    
    @Binding var offset: CGFloat
    @StateObject var viewModel: InsightPageViewModel
    
    var body: some View {
        VStack{
            Spacer()
            
            ZStack {
                VStack {
                    Spacer()
                    Text(viewModel.insight.title  ?? "")
                        .frame(alignment: .center)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(Font.system(size: 24, weight: .semibold))
                        .padding(.horizontal, 20)
                        .opacity(1 - getTopBarTitleOpacity())
                    Spacer()
                }
                .padding(.top, 30)
                .frame(width: UIScreen.main.bounds.width, height: topBarHeight)
                .background {
                    VStack {
                        Spacer()
                        Rectangle()
                            .cornerRadius(60, corners: [.topLeft, .topRight])
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width, height: topBarHeight)
                            .shadow(radius: 4, y: -6)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: maxHeight)
    }
    
    func getTopBarTitleOpacity() -> CGFloat {
        let progress = -(offset + topBarHeight) / (maxHeight - (80 + topEdge) - 200)
        
        return progress
    }
}

