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
        
        store.fetchLatestEpisodes { result in
            // TODO: fetch from db
            switch result {
            case let .success(episodes):
                self.episodeDataSource.episodes = episodes
            case .failure:
                self.episodeDataSource.episodes.removeAll()
            }
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

}

