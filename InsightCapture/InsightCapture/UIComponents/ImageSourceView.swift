//
//  ImageSourceView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI
import SwiftUIImageViewer

struct PageImageSourceView: View {
    @State var isShowingImage: Bool = false
    
    @EnvironmentObject var pageViewModel: InsightPageViewModel
    
    var body: some View {
        Button {
            isShowingImage = true
        } label: {
            if pageViewModel.insight.image != nil {
                Image(uiImage: UIImage(data: pageViewModel.insight.image!)!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(18, corners: .allCorners)
            }
        }
        .navigationDestination(isPresented: $isShowingImage) {
            if pageViewModel.insight.image != nil {
                SwiftUIImageViewer(image: Image(uiImage: UIImage(data: pageViewModel.insight.image!)!))
                    .background(Color.black)
                    .navigationBarBackButtonHidden()
                    .toolbarBackground(.hidden, for: .navigationBar)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(alignment: .topLeading) {
                        Button {
                            self.isShowingImage = false
                        } label: {
                            Label("", systemImage: "arrow.left")
                                .foregroundColor(.white)
                                .font(Font.system(size: 16, weight: .bold))
                        }
                        .padding(.leading, 16)
                    }
            }
        }
    }
}

struct CardImageSourceView: View {
    @StateObject var insight: InsightData
    
    var body: some View {
        ZStack {
            if insight.image == nil {
                // 이미지가 없는 경우
            } else {
                Image(uiImage: UIImage(data: insight.image!)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.size.width - 32 - 16, height: (UIScreen.main.bounds.size.width - 32 - 16) * 0.56)
                    .cornerRadius(8)
                    .clipped()
            }
        }
        .padding(.horizontal, 8)
    }
}
