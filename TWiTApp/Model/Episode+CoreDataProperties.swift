//
//  Episode+CoreDataProperties.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 8/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var airingDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var showNotes: String?
    @NSManaged public var teaser: String?
    @NSManaged public var title: String?
    @NSManaged public var videoHdUrl: String?
    @NSManaged public var videoLargeUrl: String?
    @NSManaged public var videoSmallUrl: String?
    @NSManaged public var episodeNumber: String?
    @NSManaged public var show: Show?

}
