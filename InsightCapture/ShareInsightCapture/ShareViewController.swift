//
//  ShareViewController.swift
//  ShareInsightCapture
//
//  Created by Park Sungmin on 2023/03/12.
//

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
        return view
    }()
    
    lazy var sourceView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var sourceTitleBar: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var sourceTitle: UILabel = {
        let label = UILabel()
        label.text = "출처"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var sourceToggleButton: UIButton = {
        let button = UIButton()
        button.setTitle("토글", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
//        button.addTarget(self, action: #selector(tapToggleButton), for: .touchUpInside)
        return button
    }()
    
    lazy var thumbnailTitleLabelView: UILabel = {
        let label = UILabel()
        label.text = "타이틀"
        return label
    }()
    
    lazy var thumbnailDescriptionLabelView: UILabel = {
        let label = UILabel()
        label.text = "설명"
        return label
    }()
    
    lazy var insightTextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .systemGray5
        field.textAlignment = .left
        field.contentVerticalAlignment = .top
        return field
    }()
    
    // MARK: Image UI
    
    lazy var thumbnailImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    
    override func viewDidLoad() {
        setLayout()
        print("DEBUG : ", CoreDataManager.shared.getAllInsights())
        
        // MARK: Data 가져오기
        
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        
        // 가져온 데이터 중에서
        for items in extensionItems {
            // NSItemProvider 배열에 담긴 여러 미디어 데이터 중에서
            if let itemProviders = items.attachments {
                // 미디어 데이터를 하나 확인해서
                for itemProvider in itemProviders {
                    // 이미지 파일에 대한 확인
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { (data, error) in
                            
                            if let data = data {
                                self.thumbnailImage = UIImage(data: NSData(contentsOf: (data as! NSURL) as URL)! as Data)

                                
                                
                                DispatchQueue.main.async {
                                    self.setSourceThumbnailLayout()
                                }
                            }
                        }
                    }
                    
                    // URL 타입에 대한 확인
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
            $0.width.height.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(30)
        }
        
        self.backgroundView.addSubview(sourceView)
        setSourceViewLayout()
        
        self.view.addSubview(insightTextField)
        insightTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(sourceView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func setSourceViewLayout() {
        sourceView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(30)
            $0.height.equalTo(140)
        }
        
        setSourceBarLayout()
        setSourceThumbnailLayout()
    }
    
    func setSourceBarLayout() {
        self.sourceView.addSubview(sourceTitleBar)
        sourceTitleBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        self.sourceTitleBar.addSubview(sourceTitle)
        sourceTitle.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
        
        self.sourceTitleBar.addSubview(sourceToggleButton)
        sourceToggleButton.snp.makeConstraints {
            $0.top.right.equalToSuperview()
        }
    }
    
    func setSourceThumbnailLayout() {
        thumbnailImageView.image = thumbnailImage
        
        sourceView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.height.equalTo(90)
            $0.width.equalTo(120)
            $0.left.equalToSuperview()
            $0.top.equalTo(sourceTitleBar.snp.bottom)
        }
        
        sourceView.addSubview(thumbnailTitleLabelView)
        thumbnailTitleLabelView.snp.makeConstraints {
            $0.left.equalTo(thumbnailImageView.snp.right)
            $0.top.equalTo(thumbnailImageView)
            $0.right.equalTo(sourceView)
            $0.height.equalTo(40)
        }
        
        sourceView.addSubview(thumbnailDescriptionLabelView)
        thumbnailDescriptionLabelView.snp.makeConstraints {
            $0.left.equalTo(thumbnailImageView.snp.right)
            $0.top.equalTo(thumbnailTitleLabelView.snp.bottom)
            $0.right.equalTo(sourceView)
            $0.height.equalTo(40)
        }
    }
}

extension ShareViewController {
//    @objc
//    func tapToggleButton() {
//        print("toggled")
//        isShowingSource.toggle()
//
//        self.sourceView.snp.updateConstraints {
//            $0.centerX.equalToSuperview()
//            $0.width.equalToSuperview().offset(-16)
//            $0.top.equalToSuperview().offset(30)
//            $0.height.equalTo(self.isShowingSource ? 180 : 40)
//        }
//
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
    
    @objc
    func tapSaveButton() {
        
        let insight = Insight(insightString: self.insightTextField.text ?? "",
                              thumbnailImage: self.thumbnailImage)
        
        CoreDataManager.shared.createInsight(insight: insight)
                
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}
