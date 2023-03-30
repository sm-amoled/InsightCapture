//
//  InsightPageView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI

struct InsightPageView: View {
    @StateObject var viewModel: InsightPageViewModel
    @State var offset: CGFloat = 0
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @GestureState private var dragOffset = CGSize.zero
    
    let maxHeight = UIScreen.main.bounds.height / 2.6
    let topEdge: CGFloat = 15
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    GeometryReader { proxy in
                        TopBar(maxHeight: maxHeight, offset: $viewModel.offset, viewModel: viewModel)
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeaderHeight(), alignment: .bottom)
                            .background {
                                Color.mint
                            }
                    }
                    .frame(height: maxHeight)
                    .offset(y: -viewModel.offset)
                    .zIndex(1)
                    
                    VStack {
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                        Text("Hello, World")
                            .frame(height: 100)
                    }
                    .zIndex(0)
                }
                .modifier(OffsetModifier(offset: $viewModel.offset))
            }
        }
        .background(Color.gray)
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
                    .opacity(getToolbarTitleOpacity() )
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .font(Font.system(size: 16, weight: .medium))
                }
            }
        }
        //210에서 색 보여주기
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + viewModel.offset
        
        return max(topHeight, 80 + topEdge)
    }
    
    func getTopBarTitleOpacity() -> CGFloat {
        let progress = -(viewModel.offset + 120 ) / (maxHeight - (80 + topEdge) - 150)
        
        return progress
    }
    
    func getToolbarTitleOpacity() -> CGFloat {
        let progress = -(viewModel.offset + 120) / (maxHeight - (80 + topEdge) - 100)
        return progress
    }
}

struct TopBar: View {
    let topBarHeight: CGFloat = 120
    var maxHeight: CGFloat
    var topEdge: CGFloat = 15
    
    
    @Binding var offset: CGFloat
    @ObservedObject var viewModel: InsightPageViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.insight.title  ?? "")
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(Font.system(size: 24, weight: .semibold))
                .padding()
                .opacity(1 - getTopBarTitleOpacity())
            Divider()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 260)
        .padding(.horizontal, 26)
        .background(
            ZStack {
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle()
                            .cornerRadius(getCornerRadius(), corners: [.topLeft, .topRight])
                            .foregroundColor(.white)
                            .frame(height: topBarHeight)
                    }
                }
            }
        )
    }
    
    func getCornerRadius() -> CGFloat {
        let progress = -offset / 110
        let cornerRadius = (1 - progress) * topBarHeight/2
        
//        return offset > 0 ? topBarHeight/2 : (cornerRadius > 0 ? cornerRadius : 0)
        return topBarHeight/2
    }
    
    func getTopBarTitleOpacity() -> CGFloat {
        let progress = -(offset + topBarHeight) / (maxHeight - (80 + topEdge) - 200)
        
        return progress
    }
}
