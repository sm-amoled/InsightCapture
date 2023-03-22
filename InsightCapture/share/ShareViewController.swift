import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

import SnapKit

class ShareViewController: UIViewController {
    
    var isShowingSource: Bool = true
    var thumbnailImage: UIImage?
    
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
        item.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
        item.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: nil)
        
        bar.items = [item]
        
        return bar
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    } ()
    
    lazy var sourceView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var sourceImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
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
        
        // 가져온 데이터 중에서
        for items in extensionItems {
            // NSItemProvider 배열에 담긴 여러 미디어 데이터 중에서
            if let itemProviders = items.attachments {
                // 미디어 데이터를 하나 확인해서
                for itemProvider in itemProviders {
                    
                    // 만약 이미지 파일이라면
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (data, error) in
                            
                            if let data = data {
                                let image = UIImage(data: NSData(contentsOf: (data as! NSURL) as URL)! as Data)
                                
                                DispatchQueue.main.async {
                                    self.sourceImageView.image = image
                                }
                            }
                        }
                    }
                    
                    // 만약 URL 타입이라면
                    if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                        
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
        setImageSourceLayout()
        
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
    }
    
    func setTextFieldLayout() {
        textFieldView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(sourceView.snp.bottom)
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
}

extension ShareViewController {
    
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
