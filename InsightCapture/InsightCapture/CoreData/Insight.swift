//
//  Insight.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/25.
//

import UIKit
import Foundation

class Insight {
    public var type: Int16
    public var content: String?
    public var createdDate: Date?
    public var title: String?
    public var urlString: String?
    public var urlTitle: String?
    public var image: Data?
    public var quote: String?
    
    init(title: String, content: String, url: URL, thumbnailImage: UIImage?, urlTitle: String) {
        self.type = InsightType.url.rawValue
        self.createdDate = Date()
        self.title = title
        self.content = content
        
        self.urlString = url.absoluteString
        self.urlTitle = urlTitle
        self.image = thumbnailImage?.pngData() ?? UIImage(systemName: "square.split.diagonal.2x2")?.pngData()
    }
    
    init(title: String, content: String, image: UIImage?) {
        self.type = InsightType.image.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.content = content == "" ? "NO_Content" : content
        
        self.image = image?.pngData() ?? UIImage(systemName: "square.split.diagonal.2x2")?.pngData()
    }
    
    init(title: String, content: String, quote: String) {
        self.type = InsightType.quote.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.content = content == "" ? "NO_Content" : content
        
        self.quote = quote
    }
    
    init(title: String, content: String) {
        self.type = InsightType.brain.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.content = content == "" ? "NO_Content" : content
    }
}

enum InsightType: Int16 {
    case image, url, quote, brain
}
