//
//  EpisodeStore.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import Foundation

struct TwitDataStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession.init(configuration: config)
    }()
    
    func fetchLatestEpisodes(completion: @escaping (Result<[Episode],Error>) -> Void) {
        let request = APIFetcher.latestEpisodesURLRequest
        let task = session.dataTask(with: request) { data, response, error in
            self.processEpisodeRequest(data: data, error: error) { result in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            }
        }
        task.resume()
    }
    
    private func processEpisodeRequest(data: Data?, error: Error?, completion: @escaping (Result<[Episode],Error>) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }
        
        switch APIFetcher.episodes(fromJSON: jsonData) {
        case let .success(twitEpisodes):
            // TODO: Find existing episodes
            
            let episodes = twitEpisodes.map {
                return Episode(
                    id: $0.id,
                    label: $0.label,
                    teaser: $0.teaser
                )
            }
            completion(.success(episodes))
            
        case let .failure(error):
            completion(.failure(error))
        }
    }
    
}
