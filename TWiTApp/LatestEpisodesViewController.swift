//
//  ViewController.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import UIKit

class LatestEpisodesViewController: UIViewController, UITableViewDelegate, UITableViewDataSourcePrefetching {
        
    var store: EpisodeStore!
    private var episodeDataSource = EpisodeDataSource()
    
    @IBOutlet var loadingView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = episodeDataSource
        tableView.prefetchDataSource = self
                
        loadNextLatestEpisodes()
    }
    
    func loadNextLatestEpisodes() {
        store.fetchLatestEpisodes { result in
            self.loadingView.stopAnimating()
            if case let .success(episodes) = result {
                self.updateDataSource(newEpisodes: episodes)
            }
        }
    }
    
    private func updateDataSource(newEpisodes: [Episode]) {
        episodeDataSource.episodes = store.latestEpisodes
        tableView.insertRows(at: getIndexPaths(for: newEpisodes), with: .fade)
    }
    
    private func getIndexPaths(for episodes: [Episode]) -> [IndexPath] {
        return episodes.compactMap { episode -> IndexPath? in
            if let index = episodeDataSource.episodes.firstIndex(of: episode) {
                return IndexPath(row: index, section: 0)
            } else {
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastItemIndexPath = IndexPath(row: episodeDataSource.episodes.count - 1, section: 0)
        if indexPaths.contains(lastItemIndexPath) {
            loadNextLatestEpisodes()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showEpisodeDetail":
            if let episodeDetailViewController = segue.destination as? EpisodeDetailViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    let episode = episodeDataSource.episodes[selectedIndexPath.row]
                    episodeDetailViewController.episode = episode
                }
            }
        default:
            preconditionFailure("Storyboard segue not found")
        }
    }

}

