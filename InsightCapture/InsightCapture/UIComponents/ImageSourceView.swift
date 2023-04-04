//
//  ImageSourceView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI

struct ImageSourceView: View {
    @State var insight: InsightData
    
    var body: some View {
        Image(uiImage: UIImage(data: insight.image!)!)
            .resizable()
            .scaledToFit()
            .cornerRadius(18, corners: .allCorners)
    }
}

