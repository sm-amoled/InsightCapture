//
//  ImageSourceView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI
import SwiftUIImageViewer

struct ImageSourceView: View {
    @State var insight: InsightData
    @State var isShowingImage: Bool = false
    
    var body: some View {
        Button {
            isShowingImage = true
        } label: {
            if insight.image != nil {
                Image(uiImage: UIImage(data: insight.image!)!)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(18, corners: .allCorners)
            }
        }
        .navigationDestination(isPresented: $isShowingImage) {
            if insight.image != nil {
                
                SwiftUIImageViewer(image: Image(uiImage: UIImage(data: insight.image!)!))
                    .background(Color.black)
                    .navigationBarBackButtonHidden()
                    .toolbarBackground(.hidden, for: .navigationBar)
                    .edgesIgnoringSafeArea(.all)
                //                .preferredColorScheme(.dark)
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
