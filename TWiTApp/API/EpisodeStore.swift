//
//  EpisodeStore.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import Foundation
import CoreData

class EpisodeStore {
    
    private var currentPage = 1
    var latestEpisodes = [Episode]()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession.init(configuration: config)
    }()
    
    func fetchLatestEpisodes(completion: @escaping (Result<[Episode],Error>) -> Void) {
        fetchLatestEpisodes(withPage: currentPage) { result in
            switch result {
            case let .success(episodes):
                self.currentPage += 1
                
                let existingEpisdes = episodes.filter { self.latestEpisodes.contains($0) }
                let newEpisdes = episodes.filter { !self.latestEpisodes.contains($0) }
                
                existingEpisdes.forEach { episode in
                    if let index = self.latestEpisodes.firstIndex(of: episode) {
                        self.latestEpisodes[index] = episode
                    }
                }
                
                self.latestEpisodes.append(contentsOf: newEpisdes)
                
                OperationQueue.main.addOperation {
                    completion(.success(newEpisdes))
                }
            case let .failure(error):
                OperationQueue.main.addOperation {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func fetchLatestEpisodes(withPage page: Int, completion: @escaping (Result<[Episode],Error>) -> Void) {
        let request = APIFetcher.getLatestEpisodesRequest(withPage: page)
        let task = session.dataTask(with: request) { data, response, error in
            self.processEpisodeRequest(data: data, error: error) { result in
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processEpisodeRequest(data: Data?, error: Error?, completion: @escaping (Result<[Episode],Error>) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }
        
        completion(APIFetcher.episodes(fromJSON: jsonData))
    }
}
