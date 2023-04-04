//
//  QuoteSourceView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/04/03.
//

import SwiftUI

struct QuoteSourceView: View {
    @State var insight: InsightData
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.randomColor(from: insight.createdDate ?? Date()))
                .padding(.horizontal, 50)
            
            VStack {
                Image(systemName: "quote.opening")
                    .padding(.top, 8)
                
                Text(insight.quote ?? "")
                    .font(Font.system(size: 16, weight: .medium))
                    .lineLimit(3)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                
                Rectangle()
                    .background(Color.black)
                    .frame(height: 1)
                    .padding(.horizontal, 15)
                
                HStack {
                    Spacer()
                }
            }
            .padding(.all, 8)
            .padding(.vertical, 16)
            .cornerRadius(10)
        }
    }
}
