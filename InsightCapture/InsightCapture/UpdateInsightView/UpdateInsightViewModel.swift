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
    
    init(insight: InsightData) {
        self.insightData = insight
        
        self.inputTitle = insight.title ?? ""
        self.inputContent = insight.content ?? ""
        
        self.sourceType = InsightType(rawValue: insight.type) ?? .brain
        
        if self.sourceType == .url {
            fetchData(from: URL(string: insight.urlString!)!) { result in
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
        self.sourceUrl = insight.urlString ?? ""
        self.sourceImage = insight.image != nil ? UIImage(data: insight.image!) : nil
        
        isSourceContentLoaded = true
        isFetchingData = false
    }
    
    func checkUrlInput() {
        guard let url = URL(string: sourceUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
//        print("Fetch Start")
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
        
        switch(sourceType) {
        case .image:
            insightData.title = inputTitle
            insightData.content = inputContent
            insightData.image = sourceImage?.pngData()
            
        case .url:
            insightData.title = inputTitle
            insightData.content = inputContent
            insightData.urlString = sourceUrl
            insightData.urlTitle = sourceTitle
            insightData.image = sourceImage?.pngData()
            
        case .quote:
            insightData.title = inputTitle
            insightData.content = inputContent
            insightData.quote = sourceQuote
            
        case .brain:
            insightData.title = inputTitle
            insightData.content = inputContent
            
        }
        
//        self.insightData.objectWillChange.send()
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