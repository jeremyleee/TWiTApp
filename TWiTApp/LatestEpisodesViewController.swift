//
//  ViewController.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import UIKit

class LatestEpisodesViewController: UIViewController, UITableViewDelegate {
    
    var store: TwitDataStore!
    private var episodeDataSource = EpisodeDataSource()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = episodeDataSource
        
        updateDataSource()
        
        store.fetchLatestEpisodes { result in
            self.updateDataSource()
        }
    }
    
    private func updateDataSource() {
        store.fetchAllEpisodes { result in
            switch result {
            case let .success(episodes):
                self.episodeDataSource.episodes = episodes
            case .failure:
                self.episodeDataSource.episodes.removeAll()
            }
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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

