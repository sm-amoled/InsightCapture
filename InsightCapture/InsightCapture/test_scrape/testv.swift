//
//  testv.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/12.
//

import SwiftUI

struct testv: View {
    
    @StateObject public var appGroupStore: AppGroupStore = AppGroupStore(appGroupID: "group.com.led.insightcapture")
    
    @State private var image: UIImage?
    @State private var url: String?
    
    var body: some View {
        VStack {
            Text(((appGroupStore.getSharedURL() == nil ? "not" : appGroupStore.getSharedURL())!))
            
            if appGroupStore.getSharedImage() != nil {
                Image(uiImage: appGroupStore.getSharedImage()!)
                    .resizable()
                    .frame(width: 150, height: 100)
            }
        }
        .onAppear {
            print(appGroupStore.getSharedImage())
        }
    }
}

struct testv_Previews: PreviewProvider {
    static var previews: some View {
        testv()
    }
}
