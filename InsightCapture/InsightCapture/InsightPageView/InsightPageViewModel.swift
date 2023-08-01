//
//  InsightPageViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI
import LinkPresentation
import UniformTypeIdentifiers

class InsightPageViewModel: ObservableObject {
    
    @Published var insight: InsightData
    @Published var offset: CGFloat
    
    @Published var image: UIImage?
    @Published var isShowingActions: Bool = false
    
    let maxHeight = UIScreen.main.bounds.height / 2.6
    let topEdge: CGFloat = 15
    
    init(insight: InsightData) {
        self.insight = insight
        self.offset = 0
        
        switch(insight.type) {
        case InsightType.image.rawValue:
            guard let contentImage = insight.image else { return }
            image = UIImage(data: contentImage)!
            
        case InsightType.url.rawValue:
            guard let contentImage = insight.image else { return }
            image = UIImage(data: contentImage)!
            
        case InsightType.quote.rawValue:
            let _ = 0
            
        case InsightType.brain.rawValue:
            let _ = 0
            
        default:
            let _ = 0
        }
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return max(topHeight, 80 + topEdge)
    }
    
    func getTopBarTitleOpacity() -> CGFloat {
        let progress = -(offset + 120 ) / (maxHeight - (80 + topEdge) - 150)
        
        return progress
    }
    
    func getToolbarTitleOpacity() -> CGFloat {
        let progress = -(offset + 120) / (maxHeight - (80 + topEdge) - 100)
        return progress
    }
    
    func fetchImage(from url: URL) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metaData, error in
            if error == nil { return }
            guard let data = metaData else { return }
            
            data.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                guard error == nil else { return }
                
                if let image = image as? UIImage {
                    self.image = image
                } else {
                    print("no image available")
                }
            })
        }
    }
    
    func deleteInsight() {
        CoreDataManager.shared.deleteInsight(insightData: insight)
    }
}
