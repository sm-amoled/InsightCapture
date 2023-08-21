//
//  InsightHistoryManager.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/20.
//

import Foundation

final class InsightHistoryManager {
    static let shared = InsightHistoryManager()
    
    var firstDayDistance: DateComponents!
    var runCount: Int!
    var insightCount: Int!
    var mostInsightSource: String!
    
    var insightSourceTable: [String: Int]! = [:]
    
    init() {
        refreshHistory()
        loadInsightSourceTable()
    }
    
    func refreshHistory() {
        firstDayDistance = getFirstDayDistance()
        runCount = getRunCount()
        insightCount = getInsightCount()
        mostInsightSource = getMostInsightSource()
    }
    
    func getFirstDayDistance() -> DateComponents {
        let firstDay = UserDefaults.standard.object(forKey: "FirstDay") as! Date
        
        let dateDistance = Calendar.current.dateComponents([.year, .month, .day], from: Date(), to: firstDay)
        return dateDistance
    }
    
    func getRunCount() -> Int {
        let count = UserDefaults.standard.integer(forKey: "RunCount")
        return count
    }
    
    func getInsightCount() -> Int {
        let count = CoreDataManager.shared.getAllInsights().count
        return count
    }
    
    func getMostInsightSource() -> String {
        let mostSource = insightSourceTable.max{$0.value < $1.value}?.key ?? ""
        return mostSource == "" ? "NONE" : mostSource
    }
    
    func loadInsightSourceTable() {
        let historyJSON = UserDefaults.standard.string(forKey: "InsightHistory") ?? ""
        
        if historyJSON == "" {
            insightSourceTable = [:]
            return
        }
        
        do {
            insightSourceTable = try JSONSerialization.jsonObject(with: Data(historyJSON.utf8), options: []) as? [String:Int]
        } catch {
            print("DEBUG : JSON PARSING ERROR")
        }
    }
    
    func saveInsightSourceTable() {
        if let historyData = try? JSONSerialization.data(
            withJSONObject: insightSourceTable!,
            options: []) {
            let historyJSON = String(data: historyData,
                                     encoding: .utf8) ?? ""
            UserDefaults.standard.set(historyJSON, forKey: "InsightHistory")
        }
    }
    
    func addInsightSourceItem(source: String) {
        if insightSourceTable[source] != nil {
            insightSourceTable.updateValue(insightSourceTable[source]! + 1, forKey: source)
        } else {
            insightSourceTable.updateValue(1, forKey: source)
        }
        saveInsightSourceTable()
        refreshHistory()
    }
    
    func removeInsightSourceItem(source: String) {
        insightSourceTable.updateValue((insightSourceTable[source] ?? 1) - 1, forKey: source)
        saveInsightSourceTable()
        refreshHistory()
    }
}
