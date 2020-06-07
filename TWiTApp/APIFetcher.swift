//
//  APIFetcher.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import Foundation

enum EndPoint: String {
    case episodes = "episodes"
}

struct APIFetcher {
    
    private static let baseURLString = "https://twit.tv/api/v1.0"
    private static let apiAppID = "e71e1b45"
    private static let apiKey = "6b602234dcdf7ead0fdc7e524c799b36"
    
    private static var headers = [
        "Accept": "application/json",
        "app-id": apiAppID,
        "app-key": apiKey
    ]
    
    static var latestEpisodesURLRequest: URLRequest {
        return twitURL(endPoint: .episodes, parameters: nil)
    }
    
    private static func twitURL(endPoint: EndPoint, parameters: [String:String]?) -> URLRequest {
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        let url = components.url!.appendingPathComponent(endPoint.rawValue)
        var request = URLRequest(url: url)
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    static func episodes(fromJSON data: Data) -> Result<[TwitEpisode],Error> {
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let response = try decoder.decode(TwitEpisodeResponse.self, from: data)
            return .success(response.episodes)
        } catch {
            return .failure(error)
        }
    }
    
}

struct TwitEpisodeResponse: Codable {
    let episodes: [TwitEpisode]
}
