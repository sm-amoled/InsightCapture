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
    public var text: String?
    public var createdDate: Date?
    public var title: String?
    public var urlString: String?
    public var image: Data?
    public var quote: String?
    
    init(url: URL, text: String, title: String, thumbnailImage: UIImage? = nil) {
        self.type = InsightType.url.rawValue
        self.text = text
        self.createdDate = Date()
        self.title = title
        self.urlString = url.absoluteString
        self.image = thumbnailImage?.pngData()
    }
    
    init(image: UIImage, text: String, title: String) {
        self.type = InsightType.image.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.text = text == "" ? "NO_Content" : text
        self.image = image.pngData()
    }
    
    init(quote: String, text: String, title: String) {
        self.type = InsightType.quote.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.text = text == "" ? "NO_Content" : text
        self.quote = quote
    }
    
    init(text: String, title: String) {
        self.type = InsightType.brain.rawValue
        self.createdDate = Date()
        self.title = title == "" ? "NO_title" : title
        self.text = text == "" ? "NO_Content" : text
    }
}

enum InsightType: Int16 {
    case image, url, quote, brain
}
