//
//  URLThumbnailView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI

struct URLSourceView: View {
    @State var insight: InsightData
    
    var body: some View {
        HStack {
            if insight.image != nil {
                Image(uiImage: UIImage(data: insight.image!)!)
                    .resizable()
                    .frame(width: 136, height: 76)
                    .clipped()
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 136, height: 76)
            }
            VStack(alignment: .leading) {
                Text(insight.title ?? "")
                    .font(Font.system(size: 15, weight: .bold))
                    .lineLimit(2)
                    .padding(.vertical, 2)
                
                Text(URLComponents(string: insight.urlString ?? "")?.host ?? "")
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
    }
}
