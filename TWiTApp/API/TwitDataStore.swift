//
//  EpisodeStore.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import Foundation
import CoreData

struct TwitDataStore {
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TWiTApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
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
        
        persistentContainer.performBackgroundTask { context in
            switch APIFetcher.episodes(fromJSON: jsonData) {
            case let .success(twitEpisodes):
                let episodes = twitEpisodes.map { twitEpisode -> Episode in
                    let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Episode.id)) == \(twitEpisode.id)")
                    
                    var fetchedEpisodes: [Episode]?
                    context.performAndWait {
                        fetchedEpisodes = try? fetchRequest.execute()
                    }
                    if let existingEpisode = fetchedEpisodes?.first {
                        return existingEpisode
                    }
                    
                    var episode: Episode!
                    context.performAndWait {
                        episode = Episode(context: context)
                        episode.id = Int64(twitEpisode.id)
                        episode.title = twitEpisode.label
                        episode.teaser = twitEpisode.teaser
                        episode.airingDate = twitEpisode.airingDate
                        episode.videoHdUrl = twitEpisode.videoHdInfo?.mediaUrl
                        episode.videoLargeUrl = twitEpisode.videoLargeInfo?.mediaUrl
                        episode.videoSmallUrl = twitEpisode.videoSmallInfo?.mediaUrl
                    }
                    return episode
                }
                
                do {
                    try context.save()
                } catch {
                    print("Error saving to Core Data: \(error).")
                    completion(.failure(error))
                    return
                }
                
                let episodeIDs = episodes.map { $0.objectID }
                let viewContext = self.persistentContainer.viewContext
                let viewContextEpisodes = episodeIDs.map { viewContext.object(with: $0) } as! [Episode]
                completion(.success(viewContextEpisodes))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllEpisodes(completion: @escaping (Result<[Episode],Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Episode.airingDate), ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        
        persistentContainer.viewContext.perform {
            do {
                let allEpisodes = try fetchRequest.execute()
                completion(.success(allEpisodes))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
