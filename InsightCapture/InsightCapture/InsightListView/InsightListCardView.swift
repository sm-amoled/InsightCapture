//
//  InsightListCardView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/27.
//

import SwiftUI
import LinkPresentation

struct InsightListCardView: View {
    
    @State var insightList: [InsightData] = []
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemGray5))
            ScrollView {
                ForEach(insightList) { insightData in
                    switch(insightData.type) {
                    case InsightType.image.rawValue:
                        InsightListImageCardView(insight: insightData)
                    case InsightType.url.rawValue:
                        InsightListURLCardView(insight: insightData)
                    case InsightType.quote.rawValue:
                        InsightListQuoteCardView(insight: insightData)
                    case InsightType.brain.rawValue:
                        InsightListBrainCardView(insight: insightData)
                    default:
                        EmptyView()
                    }
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
                Text(insight.createdDate!.createCardDateString())
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

struct InsightListURLCardView: View {
    @State var insight: InsightData
    
    @State var urlImage: UIImage?
    @State var urlTitle: String?
    @State var urlDescription: String?
    
    var body: some View {
        VStack {
            HStack {
                Text(insight.createdDate!.createCardDateString())                    .font(Font.system(size: 13, weight: .medium))
                
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
                    HStack {
                        if urlImage != nil {
                            Image(uiImage: urlImage!)
                                .resizable()
                                .frame(width: 136, height: 76)
                                .clipped()
                        } else {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 136, height: 76)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(urlTitle ?? "")
                                .font(Font.system(size: 15, weight: .bold))
                                .lineLimit(2)
                                .padding(.vertical, 2)
                            
                            Text(urlDescription ?? "")
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
                    
                    if urlImage == nil {
                        ProgressView()
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
        .onAppear {
            // Insight 내 URL 에서 필요한 정보 불러오기
            guard let url = URL(string: insight.urlString ?? "") else { return }
            
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: url) { metaData, error in
                if error != nil { return }
                guard let data = metaData else { return }
                
                self.urlTitle = data.title
                self.urlDescription = (data.value(forKey: "summary") as! String)
                
                data.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in

                    if error != nil { return }
                    guard let image = image else { return }
                    
                    self.urlImage = (image as! UIImage)
                })
            }
        }
    }
}

struct InsightListQuoteCardView: View {
    @State var insight: InsightData
    
    @State var quote: String?
    
    var body: some View {
        VStack {
            HStack {
                Text(insight.createdDate!.createCardDateString())                    .font(Font.system(size: 13, weight: .medium))
                
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
                        
                        HStack {
                            Spacer()
                        }
                    }
                    .padding(.all, 8)
                    .cornerRadius(10)
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

struct InsightListBrainCardView: View {
    @State var insight: InsightData
    
    var body: some View {
        VStack {
            HStack {
                Text(insight.createdDate!.createCardDateString())                    .font(Font.system(size: 13, weight: .medium))
                
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
            .padding(.bottom, 16)
            
            VStack(alignment: .leading) {
                
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
