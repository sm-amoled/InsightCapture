//
//  UpdateInsightViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/24.
//

import SwiftUI
import LinkPresentation

class UpdateInsightViewModel: ObservableObject {
    var insightData: InsightData
    
    @Published var inputTitle: String
    @Published var inputContent: String
    
    @Published var sourceType: InsightType
    
    @Published var sourceUrl = ""
    @Published var sourceImage: UIImage? = nil
    @Published var sourceTitle = ""
    @Published var sourceQuote = ""
    @Published var sourceName = "DEBUG"
    
    // Photo Picker
    @Published var isImagePickerPresented = false
    @Published var selectedImage: UIImage?
    
    @Published var isSourceContentLoaded = false
    @Published var isFetchingData = false
    
    let titlePlaceholderText = PlaceholderList.titlePlaceholder.randomElement() ?? "제목"
    let contentPlaceholderText = PlaceholderList.contentPlaceholder.randomElement() ?? "내용"
    
    init(insight: InsightData) {
        self.insightData = insight
        
        self.inputTitle = insight.title ?? ""
        self.inputContent = insight.content ?? ""
        
        self.sourceType = InsightType(rawValue: insight.type) ?? .brain
        
        switch self.sourceType {
        case .url:
            self.isFetchingData = true
            
            self.sourceUrl = insightData.urlString ?? ""
            self.sourceTitle = insightData.urlTitle ?? ""
            self.sourceImage  = UIImage(data: insightData.image!)!
            
            fetchData(from: URL(string: insight.urlString!)!) { result in
                DispatchQueue.main.async {
                    self.isFetchingData = false
                    
                    if result.0 != "INIT_URL" {
                        self.sourceName = result.4
                        
                        self.isSourceContentLoaded = true
                    }
                }
            }
        case .quote:
            self.sourceQuote = insightData.quote ?? ""
            
        default:
            let _ = 0
        }
        
        self.sourceUrl = insight.urlString ?? ""
        self.sourceImage = insight.image != nil ? UIImage(data: insight.image!) : nil
        
        isSourceContentLoaded = true
        isFetchingData = false
    }
    
    func checkUrlInput() {
        guard let url = URL(string: sourceUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        isFetchingData = true
        
        fetchData(from: url) { result in
            DispatchQueue.main.async {
                self.isFetchingData = false
                
                if result.0 != "INIT_URL" {
                    self.sourceUrl = result.0
                    self.sourceTitle = result.1
                    self.sourceImage = result.3
                    self.sourceName = result.4
                    
                    self.isSourceContentLoaded = true
                }
            }
        }
    }
    
    func tapImageLoadButton() {
        isImagePickerPresented.toggle()
    }
    
    func tapSaveButton() {
        
        insightData.title = inputTitle == "" ? titlePlaceholderText : inputTitle
        insightData.content = inputContent == "" ? contentPlaceholderText : inputContent
        
        switch(sourceType) {
        case .image:
            insightData.image = sourceImage?.pngData()
            
        case .url:
            insightData.urlString = sourceUrl
            insightData.urlTitle = sourceTitle
            insightData.image = sourceImage?.pngData()
            
        case .quote:
            insightData.quote = sourceQuote
            
        case .brain:
            let _ = 0
        }
        
        CoreDataManager.shared.updateInsight()
    }
}

extension UpdateInsightViewModel {
    func fetchData(from url: URL, _ completion: @escaping ((String, String, String, UIImage?, String))->Void ) {
        var result: (url: String, title: String, description: String, image: UIImage?, sourceName: String) = ("INIT_URL","INIT_TITLE","INIT_DESCRIPTION", nil, "")
        
        let provider = LPMetadataProvider()
        print(url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        
        provider.startFetchingMetadata(for: url) { metaData, error in
            if let _ = error {
                completion(result)
                return
            }
            guard let data = metaData else {
                completion(result)
                return
            }
            
            result.url = url.absoluteString
            result.title = data.title ?? "NO_TITLE"
            result.description = data.value(forKey: "summary") as? String ?? "NO_DESCRIPTION"
            result.sourceName = data.value(forKey: "_siteName") as? String ?? "정보의 바다"
            
            data.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                guard error == nil else {
                    completion(result)
                    return
                }
                
                if let image = image as? UIImage {
                    result.image = image
                } else {
                    print("no image available")
                }
                
                completion(result)
            })
        }
    }
}

extension UpdateInsightViewModel {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        sourceImage = selectedImage
        
        isSourceContentLoaded = true
    }
}
