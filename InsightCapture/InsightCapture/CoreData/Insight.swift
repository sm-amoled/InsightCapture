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
    public var image: Data?
    public var quote: String?
    
    init(url: URL, content: String, title: String, thumbnailImage: UIImage? = nil) {
        self.type = InsightType.url.rawValue
        self.content = content
        self.createdDate = Date()
        self.title = title
        self.urlString = url.absoluteString
        self.image = thumbnailImage?.pngData()
    }
    
    init(image: UIImage, content: String, title: String) {
        self.type = InsightType.image.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.content = content == "" ? "NO_Content" : content
        self.image = image.pngData()
    }
    
    init(quote: String, content: String, title: String) {
        self.type = InsightType.quote.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.content = content == "" ? "NO_Content" : content
        self.quote = quote
    }
    
    init(content: String, title: String) {
        self.type = InsightType.brain.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.content = content == "" ? "NO_Content" : content
    }
}

enum InsightType: Int16 {
    case image, url, quote, brain
}
