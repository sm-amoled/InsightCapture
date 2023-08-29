//
//  URLThumbnailView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI

struct PageURLSourceView: View {
    @EnvironmentObject var pageViewModel: InsightPageViewModel
    
    var body: some View {
        HStack {
            if pageViewModel.insight.image != nil {
                Image(uiImage: UIImage(data: pageViewModel.insight.image!)!)
                    .resizable()
                    .frame(width: 136, height: 76)
                    .clipped()
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 136, height: 76)
            }
            VStack(alignment: .leading) {
                Text(pageViewModel.insight.urlTitle ?? "")
                    .font(Font.system(size: 15, weight: .bold))
                    .lineLimit(2, reservesSpace: true)
                    .padding(.vertical, 2)
                
                Text(URLComponents(string: pageViewModel.insight.urlString ?? "")?.host ?? "")
                    .font(Font.system(size: 12, weight: .light))
                    .lineLimit(1)
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
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
            UIApplication.shared.open(URL(string: pageViewModel.insight.urlString ?? "")!)
        }
    }
}

struct CardURLSourceView: View {
    
    let image: UIImage?
    let urlTitle: String
    let urlString: String
    
    init(image: UIImage, urlTitle: String, urlString: String) {
        self.image = image
        self.urlTitle = urlTitle
        self.urlString = urlString
    }
    
    init(insight: InsightData) {
        self.image = insight.image == nil ? nil : UIImage(data: insight.image!)!
        self.urlTitle = insight.urlTitle ?? ""
        self.urlString = insight.urlString ?? ""
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
                Text(urlTitle)
                    .font(Font.system(size: 15, weight: .bold))
                    .lineLimit(2, reservesSpace: true)
                    .padding(.vertical, 2)
                
                Text(URLComponents(string: urlString)?.host ?? "")
                    .font(Font.system(size: 12, weight: .light))
                    .lineLimit(1)
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                HStack {
                    Spacer()
                }
            }
            .padding(.horizontal, 3)
        }
        .padding(.all, 8)
        .background(Color(uiColor: UIColor.systemGray5))
        .cornerRadius(10)
        .padding(.horizontal, 8)
    }
}
