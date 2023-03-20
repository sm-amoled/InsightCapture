//
//  InsightData.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/17.
//

import UIKit

class Insight {
    var insightString: String?
    var url: String?
    var createDate: Date?
    var thumbnailImage: UIImage?
    
    init(insightString: String?, url: String?) {
        self.insightString = insightString
        self.url = url
        self.createDate = Date()
    }
    
    init(insightString: String?, thumbnailImage: UIImage?) {
        self.insightString = insightString
        self.thumbnailImage = thumbnailImage
        self.createDate = Date()
    }
}
