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


class ShareViewController: SLComposeServiceViewController {
    
//    override func viewDidLoad() {
//        self.view.backgroundColor = .systemGray6
//
//    }
    
    let appGroupStore = AppGroupStore(appGroupID: "group.com.led.InsightCapture")
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        // True/False를 통해 share 기능을 통해 앱을 선택했을 때, 입력 값에 따라 앱으로 Post 가능 여부를 설정할 수 있음
        // 입력 값은 contentText 로 접근이 가능 (SLComposeSErviceViewController을 통해 접근 가능)
        return true
    }
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        // Post 버튼을 눌렀을 때 실행되는 함수
        
//        UserDefaults.shared.changeValue(to: "colacola")
        
        appGroupStore.setSharedURL(urlString: "hello, cola")
//
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]

        var image: UIImage?
        var text: String?

        for extensionItem in extensionItems {
            if let itemProviders = extensionItem.attachments {
                for itemProvider in itemProviders {
                    // 해당 객체가 있는지 식별
                    if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { result, error in

                            if result is UIImage {
                                image = result as? UIImage
                            }
                            else if result is URL {
                                let data = try? Data(contentsOf: result as! URL)
                                image = UIImage(data: data!)!
                            }
                            else if result is Data {
                                image = UIImage(data: result as! Data)!
                            }
                            
                            self.appGroupStore.setSharedImage(image: image!)
                        })
                    }
                }
            }
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func didSelectCancel() {
        // Cancel 버튼을 눌렀을 때 실행되는 함수

    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        // Sheet 하단에 설정할 수 있는 값들을 추가할 수 있음
        //        let item = SLComposeSheetConfigurationItem()!
        //        item.title = "제목"
        //        item.tapHandler = { /* tap 했을 때의 action */}
        //        item.value = "선택"
        //        return [item]
        
        return []
    }
}
