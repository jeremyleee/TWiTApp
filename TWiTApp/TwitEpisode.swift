//
//  TwitEpisode.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import Foundation

struct TwitEpisode: Codable {
    let id: Int
    let label: String
    let cleanPath: String
    let ttl: String
    let episodeNumber: String
    let airingDate: Date
    let teaser: String
    let showNotes: String
}
