//
//  CoreDataManager.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/24.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let container = NSPersistentContainer(name: "InsightDataModel")
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private var oldStoreURL: URL {
        guard let directory = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask)
            .first
        else {
            return URL(fileURLWithPath: "")
        }
        return directory.appendingPathComponent(CoreData.databaseName)
    }
    
    private var sharedStoreURL: URL {
        guard let container = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: CoreData.identifier)
        else {
            return URL(fileURLWithPath: "")
        }
        return container.appendingPathComponent(CoreData.databaseName)
    }
    
    private init() {
        loadStores()
        migrateStore()
        context.automaticallyMergesChangesFromParent = true
    }
}

private extension CoreDataManager {
    func loadStores() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func migrateStore() {
        let coordinator = container.persistentStoreCoordinator
        guard let oldStore = coordinator.persistentStore(for: oldStoreURL) else { return }
        do {
            let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
        } catch {
            print(error.localizedDescription)
        }
        do {
            try FileManager.default.removeItem(at: oldStoreURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: CRUD

extension CoreDataManager {
    func save() {
        do {
            try context.save()
        } catch {
            print("FAIL TO SAVE CONTEXT")
        }
    }
    
    func getAllInsights() -> [InsightData] {
        let fetchRequest: NSFetchRequest<InsightData> = InsightData.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        
        return result?.reversed() ?? []
    }
    
    func createInsight(insight: Insight) {
        let newInsight = InsightData(context: context)
        
        newInsight.type = insight.type
        newInsight.createdDate = insight.createdDate
        
        newInsight.title = insight.title
        newInsight.content = insight.content
        
        newInsight.urlTitle = insight.urlTitle
        newInsight.urlString = insight.urlString
        newInsight.quote = insight.quote
        newInsight.image = insight.image
        
        save()
    }
    
    func deleteInsight(insightData: InsightData) {
        context.delete(insightData)
        save()
    }
}

enum CoreData {
    static let identifier = "group.com.led.InsightCapture"
    static let databaseName = "InsightDataModel.sqlite"
}
