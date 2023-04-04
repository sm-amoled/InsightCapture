import UIKit
import LinkPresentation
import Social
import MobileCoreServices
import UniformTypeIdentifiers
import SwiftUI

import SnapKit

class ShareViewController: UIViewController {
    
    // MARK: Properties
    var sourceType: InsightType = .brain
    
    // source - name 으로 작명하였음
    var imageThumbnailImage: UIImage?
    
    var url: URL?
    var urlThumbnailImage: UIImage?
    var urlTitle: String?
    var urlDescription: String?
    
    var quote: String?
    
    var isShowingSourceViewIndicator: Bool = false {
        willSet {
            if newValue {
                showSourceViewIndicator()
            } else {
                deleteSourceViewIndicator()
            }
        }
    }
    
    // MARK: UI Components
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 15
        view.clipsToBounds =  true
        return view
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barStyle = .default
        
        let item = UINavigationItem(title: "HELLOWORLD")
        item.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapCancelButton))
        item.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(tapSaveButton))
        
        bar.items = [item]
        
        return bar
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    } ()
    
    lazy var sourceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(Color.randomColor(from: Date()))
        view.clipsToBounds = true
        return view
    }()
    
    lazy var sourceImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var sourceTitleView: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.numberOfLines = 2
        return view
    }()
    
    lazy var sourceDescriptionView: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .light)
        view.textColor = UIColor(hex: "#535353")
        view.numberOfLines = 1
        return view
    }()
    
    lazy var sourceIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .medium
        return indicatorView
    }()
    
    lazy var quoteTextView: UILabel = {
        let label = UILabel()
        label.text = quote ?? ""
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    lazy var textFieldView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목"
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        return textField
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    let textViewPlaceHolder: String = "내용"
    lazy var descriptionTextField: UITextView = {
        let textField = UITextView()
        textField.text = textViewPlaceHolder
        textField.textColor = .systemGray2
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textContainerInset = .zero
        textField.textContainer.lineFragmentPadding = 0
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        setLayout()
        
        // MARK: Data 가져오기
        
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        isShowingSourceViewIndicator = true

        // 가져온 데이터 중에서
        for items in extensionItems {
            
            // 만약 인용 이라면
            if items.attributedContentText?.string != nil {
                sourceType = .quote
                quote = items.attributedContentText?.string ?? ""
                
                if URL(string: quote!) != nil {
                    sourceType = .url
                    self.setUrlSourceLayout()
                    
                    self.url = URL(string: quote!)
                    self.fetchData(from: url as! URL)
                    self.isShowingSourceViewIndicator = false
                    
                    return
                }
                
                self.setQuoteSourceLayout()
                return
            }
            
            // NSItemProvider 배열에 담긴 여러 미디어 데이터 중에서
            if let itemProviders = items.attachments {
                
                // 미디어 데이터를 하나 확인해서
                for itemProvider in itemProviders {
                    
                    // 만약 이미지 파일이라면
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        
                        sourceType = .image
                        self.setImageSourceLayout()
                        
                        itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (data, error) in
                            if let data = data {
                                let image = UIImage(data: NSData(contentsOf: (data as! NSURL) as URL)! as Data)
                                
                                self.imageThumbnailImage = image
                                
                                DispatchQueue.main.async {
                                    self.sourceImageView.image = image
                                    self.isShowingSourceViewIndicator = false
                                }
                            }
                        }
                    }
                    
                    // 만약 URL 타입이라면
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                        
                        sourceType = .url
                        self.setUrlSourceLayout()

                        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (url, error) in
                            self.url = url as! URL
                            
                            self.fetchData(from: url as! URL)
                            self.isShowingSourceViewIndicator = false
                        }
                    }
                }
            }
        }
    }
}

extension ShareViewController {
    func setLayout() {
        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.width.height.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(30)
        }
        
        self.backgroundView.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        self.backgroundView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
        }
        
        self.contentView.addSubview(sourceView)
        // sourceView의 layout은 Input Type에 따라 달라짐.
        
        self.contentView.addSubview(textFieldView)
        setTextFieldLayout()
    }
    
    func setImageSourceLayout() {
        sourceView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        self.sourceView.addSubview(sourceImageView)
        sourceImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.sourceView.addSubview(sourceIndicatorView)
        sourceIndicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setUrlSourceLayout() {
        self.sourceView.backgroundColor = UIColor.systemGray5
        self.sourceView.layer.cornerRadius = 10
        
        sourceView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(12)
            $0.height.equalTo(100)
        }
        
        self.sourceView.addSubview(sourceImageView)
        sourceImageView.snp.makeConstraints {
            $0.verticalEdges.left.equalToSuperview().inset(8)
            $0.width.equalTo(sourceImageView.snp.height).multipliedBy(16.0/9.0)
        }
        
        self.sourceView.addSubview(sourceTitleView)
        sourceTitleView.snp.makeConstraints {
            $0.left.equalTo(sourceImageView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(8)
            $0.top.equalToSuperview().inset(12)
            $0.height.equalTo(40)
        }
        
        self.sourceView.addSubview(sourceDescriptionView)
        sourceDescriptionView.snp.makeConstraints {
            $0.left.equalTo(sourceImageView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(8)
            $0.top.equalTo(sourceTitleView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-12)
            $0.height.equalTo(20)
        }
        
        self.sourceView.addSubview(sourceIndicatorView)
        sourceIndicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setQuoteSourceLayout() {
        sourceView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(124)
        }
        
        sourceView.addSubview(quoteTextView)
        quoteTextView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setTextFieldLayout() {
        textFieldView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(sourceView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }
        
        self.textFieldView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(textFieldView.snp.top).offset(4)
            $0.height.equalTo(30)
        }
        
        self.textFieldView.addSubview(divider)
        divider.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(titleTextField.snp.bottom).offset(8)
            $0.height.equalTo(1)
        }
        
        self.textFieldView.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(divider.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
    }
    
    func showSourceViewIndicator() {
        sourceIndicatorView.startAnimating()
    }
    
    func deleteSourceViewIndicator() {
        sourceIndicatorView.stopAnimating()
    }
}

extension ShareViewController {
    func fetchData(from url: URL) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { metaData, error in
            if let error = error { return }
            guard let data = metaData else { return }
            
            self.urlTitle = data.title
            self.urlDescription = data.value(forKey: "summary") as! String
            
            data.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                guard error == nil else { return }
                
                if let image = image as? UIImage {
                    // do something with image
                    self.urlThumbnailImage = image
                    DispatchQueue.main.async {
                        self.sourceTitleView.text = self.urlTitle
                        self.sourceDescriptionView.text = self.urlDescription
                        self.sourceImageView.image = self.urlThumbnailImage
                    }
                } else {
                    print("no image available")
                }
            })
        }
    }
    
    @objc
    func tapSaveButton() {
        var insight: Insight!
        
        switch(sourceType) {
        case .image:
            insight = .init(image: imageThumbnailImage!, text: descriptionTextField.text ?? "NO_CONTENT", title: titleTextField.text ?? "NO_TITLE")
        case .url:
            insight = .init(url: url!, text: descriptionTextField.text!, title: titleTextField.text!, thumbnailImage: urlThumbnailImage)
        case .quote:
            insight = .init(quote: quote ?? "", text: descriptionTextField.text!, title: titleTextField.text!)
        default:
            insight = .init(text: descriptionTextField.text!, title: titleTextField.text!)
        }
        
        CoreDataManager.shared.createInsight(insight: insight)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    @objc
    func tapCancelButton() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}

extension ShareViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .systemGray3
        }
    }
}
