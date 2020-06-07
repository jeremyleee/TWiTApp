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
    let videoHdInfo: VideoInfo?
    let videoLargeInfo: VideoInfo?
    let videoSmallInfo: VideoInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case label
        case cleanPath
        case ttl
        case episodeNumber
        case airingDate
        case teaser
        case showNotes
        case videoHdInfo = "video_hd"
        case videoLargeInfo = "video_large"
        case videoSmallInfo = "video_small"
    }

    struct VideoInfo: Codable {
        let mediaUrl: String
    }
}
