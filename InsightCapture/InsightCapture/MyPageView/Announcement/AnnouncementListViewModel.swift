//
//  AnnouncementViewModel.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/20.
//

import Foundation

final class AnnouncementListViewModel: ObservableObject {
    @Published var announcementList: [AnnouncementItem]
    
    init() {
        announcementList = [
        ]
    }
}

struct AnnouncementItem: Hashable {
    var title: String
    var content: String
    var writtenDate: Date
}
