//
//  Episode+CoreDataClass.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 8/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Episode)
public class Episode: NSManagedObject {
    
    var showEpisodeTitle: String {
        let showTitle = self.show?.title ?? ""
        let episodeNumber = self.episodeNumber ?? ""
        return "\(showTitle) \(episodeNumber)"
    }
    
}
