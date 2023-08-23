//
//  AddInsightViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/01.
//

import SwiftUI
import LinkPresentation

class AddInsightViewModel: ObservableObject {
    
    @Published var inputTitle = ""
    @Published var inputContent = ""
    
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
    
    
    init(sourceType: InsightType) {
        self.sourceType = sourceType
    }
    
    func checkUrlInput() {
        guard let url = URL(string: sourceUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        print("Fetch Start")
        isFetchingData = true
        
        let _ = fetchData(from: url) { result in
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
        var insight: Insight!
        
        switch(sourceType) {
        case .image:
            print("save with Image Source")
            insight = .init(title: inputTitle, content: inputContent, image: sourceImage)
            
            InsightHistoryManager.shared.addInsightSourceItem(source: "사진")
            
        case .url:
            print("save with URL Source")
            guard let url = URL(string: sourceUrl) else {
                print("invalid url")
                // 여기에서 토스트 메시지 등을 출력해야 할 듯?
                return
            }
            
            insight = .init(title: inputTitle, content: inputContent,
                            url: url, thumbnailImage: sourceImage, urlTitle: sourceTitle)
            
            InsightHistoryManager.shared.addInsightSourceItem(source: sourceName)
            
        case .quote:
            insight = .init(title: inputTitle, content: inputContent, quote: sourceQuote)
            
            InsightHistoryManager.shared.addInsightSourceItem(source: "인용")
            
        case .brain:
            insight = .init(title: inputTitle, content: inputContent)
            
            InsightHistoryManager.shared.addInsightSourceItem(source: "생각")
        }
        
        guard let insight = insight else { return }
        CoreDataManager.shared.createInsight(insight: insight)
    }
}

extension AddInsightViewModel {
    func fetchData(from url: URL, _ completion: @escaping ((String, String, String, UIImage?, String))->Void ) -> (String, String, String, UIImage?, String) {
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
        return result
    }
}

extension AddInsightViewModel {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        sourceImage = selectedImage
        
        isSourceContentLoaded = true
    }
}
