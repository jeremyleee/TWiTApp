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
        fetchLatestEpisodes(withPage: 1) { result in
            OperationQueue.main.addOperation {
                completion(result)
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
        
        persistentContainer.performBackgroundTask { context in
            switch APIFetcher.episodes(fromJSON: jsonData) {
            case let .success(twitEpisodes):
                let episodes = twitEpisodes.compactMap { twitEpisode in
                    self.fetchOrCreateEpisode(from: twitEpisode, with: context)
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
    
    private func fetchOrCreateEpisode(from response: TwitEpisode, with context: NSManagedObjectContext) -> Episode? {
        guard let show = fetchOrCreateShow(from: response.embedded.shows.first, with: context) else {
            return nil
        }
        
        var episode: Episode!

        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Episode.id)) == \(response.id)")
        
        context.performAndWait {
            let fetchedEpisodes = try? fetchRequest.execute()

            if let existingEpisode = fetchedEpisodes?.first {
                episode = existingEpisode
            } else {
                episode = Episode(context: context)
            }
                    
            episode.id = Int64(response.id)
            episode.title = response.label
            episode.teaser = response.teaser
            episode.showNotes = response.showNotes
            episode.episodeNumber = response.episodeNumber
            episode.airingDate = response.airingDate
            episode.videoHdUrl = response.videoHdInfo?.mediaUrl
            episode.videoLargeUrl = response.videoLargeInfo?.mediaUrl
            episode.videoSmallUrl = response.videoSmallInfo?.mediaUrl
            episode.videoAudioUrl = response.videoAudioInfo?.mediaUrl
            episode.heroImageUrl = response.heroImage.url
            episode.show = show
        }
        
        return episode
    }
    
    private func fetchOrCreateShow(from response: TwitEpisode.Embedded.Show?, with context: NSManagedObjectContext) -> Show? {
        guard let response = response, let id = Int64(response.id) else {
            return nil
        }
        
        var show: Show!
        
        let fetchShowRequest: NSFetchRequest<Show> = Show.fetchRequest()
        fetchShowRequest.predicate = NSPredicate(format: "\(#keyPath(Show.id)) == \(response.id)")
        
        context.performAndWait {
            let fetchedShows = try? fetchShowRequest.execute()
            
            if let existingShow = fetchedShows?.first {
                show = existingShow
            } else {
                show = Show(context: context)
            }
            
            show.id = id
            show.title = response.label
        }
        
        return show
    }
    
    func fetchAllEpisodes(completion: @escaping (Result<[Episode],Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Episode.airingDate), ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        fetchRequest.fetchLimit = 25
        
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
