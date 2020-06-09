//
//  TwitEpisode.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import Foundation

class Episode: Codable, Equatable {
    
    let id: Int
    let title: String
    let cleanPath: String
    let ttl: String
    let episodeNumber: String
    let airingDate: Date
    let teaser: String
    let showNotes: String
    let heroImage: HeroImage
    let videoHdInfo: VideoInfo?
    let videoLargeInfo: VideoInfo?
    let videoSmallInfo: VideoInfo?
    let videoAudioInfo: VideoInfo?
    let embedded: Embedded
    
    var show: Show? {
        embedded.shows.first
    }
    
    var showEpisodeTitle: String {
        let showTitle = self.show?.title ?? ""
        return "\(showTitle) \(episodeNumber)"
    }
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "label"
        case cleanPath
        case ttl
        case episodeNumber
        case airingDate
        case teaser
        case showNotes
        case heroImage
        case videoHdInfo = "video_hd"
        case videoLargeInfo = "video_large"
        case videoSmallInfo = "video_small"
        case videoAudioInfo = "video_audio"
        case embedded = "_embedded"
    }
    
    struct HeroImage: Codable {
        let url: String
    }

    struct VideoInfo: Codable {
        let mediaUrl: String
    }
    
    struct Embedded: Codable {
        let shows: [Show]
    }
    
}
