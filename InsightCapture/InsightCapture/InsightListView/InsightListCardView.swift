//
//  InsightListCardView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/27.
//

import SwiftUI

struct InsightListCardView: View {
    
    @State var insightList: [InsightData] = []
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemGray5))
            ScrollView {
                if !insightList.isEmpty {
                    InsightListImageCardView(insight: insightList.last!)
                }
            }
        }
        
        .onAppear {
            insightList = CoreDataManager.shared.getAllInsights()
        }
    }
}

struct InsightListImageCardView: View {
    @State var insight: InsightData
    
    var body: some View {
        VStack {
            HStack {
                Text("3일 전")
                    .font(Font.system(size: 13, weight: .medium))
                
                Spacer()
                Button {
                    // 더 보기 액션 구현하기
                } label: {
                    Image(systemName: "ellipsis")
                        .font(Font.system(size: 13, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            VStack(alignment: .leading) {
                ZStack {
                    if insight.image == nil {
                        Text("이미지 없음")
                    } else {
                        Image(uiImage: UIImage(data: insight.image!)!)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.size.width - 32 - 16, height: (UIScreen.main.bounds.size.width - 32 - 16) * 0.56)
                            .cornerRadius(8)
                            .clipped()
                        
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 6)
                
                
                Text(insight.title!)
                    .font(Font.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 4)
                
                Text(insight.text!)
                    .font(Font.system(size: 16, weight: .medium))
                    .lineLimit(3)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
                
                
                HStack {
                    Spacer()
                    Text("자세히 보기")
                        .font(Font.system(size: 13, weight: .medium))
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
            }
            .onTapGesture {
                // 눌렀을 때의 Action
            }
            
        }
        .background {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(color: .init(uiColor: UIColor(white: 0, alpha: 0.25)), radius: 4, x: 0, y: 1)
        }
        .padding(.horizontal, 16)
    }
}
