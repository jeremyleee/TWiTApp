//
//  EpisodeDataSource.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import UIKit

class EpisodeDataSource: NSObject, UITableViewDataSource {
    
    var episodes = [Episode]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
        
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.showEpisodeTitle
        cell.detailTextLabel?.text = episode.title
        
        return cell
    }
    
    
}
