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
    
    
    let maxHeight = UIScreen.main.bounds.height / 2.6
    let topEdge: CGFloat = 15
    
    init(insight: InsightData) {
        self.insight = insight
        self.offset = 0
        
        switch(insight.type) {
        case InsightType.image.rawValue:
            image = UIImage(data: insight.image!)!
            
        case InsightType.url.rawValue:
            getImageFromURL()
            
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
    
    func getImageFromURL() {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: URL(string: insight.urlString ?? "")!) { metaData, error in
            if let error = error { return }
            guard let data = metaData else { return }
            
            data.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                guard error == nil else { return }
                
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    print("no image available")
                }
            })
        }
    }
}
