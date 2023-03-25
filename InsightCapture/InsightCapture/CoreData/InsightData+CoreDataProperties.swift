//
//  InsightData+CoreDataProperties.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/24.
//
//

import Foundation
import CoreData


extension InsightData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InsightData> {
        return NSFetchRequest<InsightData>(entityName: "InsightData")
    }

    @NSManaged public var type: Int16
    @NSManaged public var text: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var urlString: String?
    @NSManaged public var image: Data?
    @NSManaged public var quote: String?

}

extension InsightData : Identifiable {

}
