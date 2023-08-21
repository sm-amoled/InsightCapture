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
    var urlSourceName: String?
    
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
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapBackground)))
        
        return view
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.barStyle = .default
        
        let item = UINavigationItem(title: "인사이트 기록")
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
    
    lazy var sourceTextColumnView: UIView = {
        return UIView()
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
    
    //    lazy var textFieldScrollView: UIScrollView = {
    //        let view = UIScrollView()
    //        view.
    //    }()
    
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
        
        textField.textContainerInset.bottom = 20
        textField.textContainerInset.left = 4
        textField.textContainerInset.right = 4
        textField.textContainer.lineFragmentPadding = 3
        
        textField.keyboardDismissMode = .onDrag
        textField.delegate = self
        textField.autocorrectionType = .no
        
        
        return textField
    }()
    
    override func viewDidLoad() {
        setLayout()
        setUpNotification()
        
        // MARK: Data 가져오기
        
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        isShowingSourceViewIndicator = true
        
        // 가져온 데이터 중에서
        for items in extensionItems {
            
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
                            self.url = url as? URL
                            
                            self.fetchData(from: url as! URL)
                            self.isShowingSourceViewIndicator = false
                        }
                    }
                    
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                        
                        self.quote = items.attributedContentText?.string ?? "NO"
                        
                        if let url = URL(string: self.quote!) {
                            sourceType = .url
                            self.setUrlSourceLayout()
                            
                            self.url = url
                            
                            DispatchQueue.main.async {
                                self.fetchData(from: url)
                                self.isShowingSourceViewIndicator = false
                            }
                        } else {
                            self.sourceType = .quote
                            self.setQuoteSourceLayout()
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
//            $0.bottom.equalToSuperview().inset(20)
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
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.top.equalToSuperview().offset(12)
            //            $0.height.equalTo(130)
        }
        
        self.sourceView.addSubview(sourceImageView)
        sourceImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalTo(136)
            $0.height.equalTo(76)
            $0.centerY.equalToSuperview()
        }
        
        self.sourceView.addSubview(sourceTextColumnView)
        sourceTextColumnView.snp.makeConstraints {
            $0.left.equalTo(sourceImageView.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.verticalEdges.equalTo(sourceImageView)
        }
        
        self.sourceTextColumnView.addSubview(sourceTitleView)
        sourceTitleView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        self.sourceTextColumnView.addSubview(sourceDescriptionView)
        sourceDescriptionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(sourceTitleView.snp.bottom).offset(8)
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
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.top.equalTo(sourceView.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
            self.urlDescription = data.value(forKey: "summary") as? String ?? ""
            self.urlSourceName = data.value(forKey: "_siteName") as? String ?? ""
            
            data.imageProvider?.loadObject(ofClass: UIImage.self, completionHandler: { image, error in
                guard error == nil else { return }
                
                if let image = image as? UIImage {
                    // do something with image
                    self.urlThumbnailImage = image
                    
                    DispatchQueue.main.async {
                        self.sourceTitleView.text = self.urlTitle
                        self.sourceDescriptionView.text = URLComponents(string: url.absoluteString)?.host
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
            insight = .init(title: titleTextField.text ?? "NO_TITLE", content: descriptionTextField.text ?? "NO_CONTENT",
                            image: imageThumbnailImage!)
        case .url:
            insight = .init(title: titleTextField.text ?? "NO_TITLE", content: descriptionTextField.text ?? "NO_CONTENT",
                            url: url!, thumbnailImage: urlThumbnailImage!, urlTitle: sourceTitleView.text ?? "NO_TITLE")
        case .quote:
            insight = .init(title: titleTextField.text ?? "NO_TITLE", content: descriptionTextField.text ?? "NO_CONTENT",
                            quote: quote ?? "")
        default:
            insight = .init(title: titleTextField.text ?? "NO_TITLE", content: descriptionTextField.text ?? "NO_CONTENT")
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

extension ShareViewController {
    @objc
    func tapBackground() {
        self.view.endEditing(true)
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.descriptionTextField.contentInset.bottom = keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 1) {
            self.descriptionTextField.contentInset = UIEdgeInsets.zero
        }
//        self.titleTextField.endEditing(true)
//        self.descriptionTextField.endEditing(true)
    }
}
