//
//  testv.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/12.
//

import SwiftUI

struct testv: View {
    
    @State var insightList: [InsightData] = []
    
    var body: some View {
        VStack {
            ForEach(insightList) { data in
                HStack {
                    if let imageData = data.thumbnailImage {
                        Image(uiImage: UIImage(data: data.thumbnailImage!)!)
                            .resizable()
                            .frame(width: 60, height:40)
                    } else {
                        Text(data.url ?? "")
                    }

                    Text(data.insightString ?? "")
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            insightList = CoreDataManager.shared.getAllInsights()
        }
    }
}

struct testv_Previews: PreviewProvider {
    static var previews: some View {
        testv()
    }
}
