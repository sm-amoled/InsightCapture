//
//  UserDefaults+.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/15.
//

import Foundation
import UIKit

enum UserDefaultsKeys: String {
    case sharedImage, sharedURL
}

class AppGroupStore: ObservableObject {
    
    let appGroupID: String!
    let userDefaults: UserDefaults!
    
    
    init(appGroupID: String) {
        self.appGroupID = appGroupID
        userDefaults = UserDefaults(suiteName: appGroupID)!
    }
    
    func setSharedImage(image: UIImage) {
        
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults(suiteName: "group.com.led.InsightCapture")!.set(encoded, forKey: "myImage")
    }
    
    func getSharedImage() -> UIImage? {
        
        guard let data = UserDefaults(suiteName: "group.com.led.InsightCapture")?.data(forKey: "myImage") else { return nil }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded)
        
        return image
    }
    
    func setSharedURL(urlString: String) {
        UserDefaults(suiteName: "group.com.led.InsightCapture")!.set(urlString, forKey: UserDefaultsKeys.sharedURL.rawValue)
    }
    
    func getSharedURL() -> String? {
        guard let data = UserDefaults(suiteName: "group.com.led.InsightCapture")!.string(forKey: UserDefaultsKeys.sharedURL.rawValue) else { return nil }
        return data
    }
}
