//
//  UINavigationController.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/29.
//

// 출처 : https://medium.com/hcleedev/swift-custom-navigationview에서-swipe-back-가능하게-하기-c3c519c59bcb
// UINavigationController의 extension으로 viewdidload를 수정하여, SwiftUI의 Navigation에서 pop gesture가 가능하게 만들어줍니다.

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
