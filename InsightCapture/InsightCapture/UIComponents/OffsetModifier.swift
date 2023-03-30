//
//  OffsetModifier.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/29.
//

import SwiftUI

struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay (
                GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
//                    print(minY)
                    
                    return Color.clear
                }
                , alignment: .top
            )
    }
}
