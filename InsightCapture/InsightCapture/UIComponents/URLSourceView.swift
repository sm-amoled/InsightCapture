//
//  URLThumbnailView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI

struct URLSourceView: View {
    
    let image: UIImage?
    let title: String
    let urlString: String
    
    init(insight: InsightData) {
        self.image = (insight.image != nil) ? UIImage(data: insight.image!) : nil
        self.title = insight.title ?? ""
        self.urlString = insight.urlString ?? ""
    }
    
    init(image: UIImage, title: String, urlString: String) {
        self.image = image
        self.title = title
        self.urlString = urlString
    }
    
    var body: some View {
        HStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: 136, height: 76)
                    .clipped()
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 136, height: 76)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .font(Font.system(size: 15, weight: .bold))
                    .lineLimit(2)
                    .padding(.vertical, 2)
                
                Text(URLComponents(string: urlString)?.host ?? "")
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
        .onTapGesture {
            UIApplication.shared.open(URL(string: urlString)!)
        }
    }
}
