//
//  ContentView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/07.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        setFirstDayHistory()
        setRunCountHistory()
        InsightHistoryManager.shared
    }
    
    var body: some View {
        InsightListView()
    }
    
    func setFirstDayHistory() {
        if (UserDefaults.standard.object(forKey: "FirstDay") == nil) {
            UserDefaults.standard.set(Date(), forKey: "FirstDay")
        }
    }
    
    func setRunCountHistory() {
        let count = UserDefaults.standard.integer(forKey: "RunCount")
        UserDefaults.standard.set(count+1, forKey: "RunCount")
    }
}
