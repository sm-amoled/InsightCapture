//
//  InsightListCardViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import UIKit
import LinkPresentation

class InsightListCardViewModel: ObservableObject  {
    
    @Published var insight: InsightData
    
    @Published var urlImage: UIImage?
    @Published var urlTitle: String?
    @Published var urlDescription: String?
    
    @Published var isShowingInsightPageView: Bool = false
    
    init(insight: InsightData) {
        self.insight = insight
        
        if insight.urlString != nil {
            // Insight 내 URL 에서 필요한 정보 불러오기
            guard let url = URL(string: insight.urlString ?? "") else { return }
            
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: url) { metaData, error in
                if error != nil { return }
                guard let data = metaData else { return }
                
                data.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                    
                    if error != nil { return }
                    guard let image = image else { return }
                    
                    DispatchQueue.main.async {
                        self.urlTitle = data.title
//                        self.urlDescription = (data.value(forKey: "summary") as! String)
                        self.urlImage = (image as! UIImage)
                    }
                })
            }
        }
    }
    
    func tapCard() {
        isShowingInsightPageView = true
    }
}
