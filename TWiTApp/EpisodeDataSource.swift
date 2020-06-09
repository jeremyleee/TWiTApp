//
//  EpisodeDataSource.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodeDataSource: NSObject, UITableViewDataSource {
    
    var episodes = [Episode]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
        
        if let episodeCell = cell as? EpisodeTableViewCell {
            let episode = episodes[indexPath.row]
            episodeCell.thumbnailImageView.sd_setImage(with: URL(string: episode.heroImage.url))
            episodeCell.titleView.text = episode.showEpisodeTitle
            episodeCell.episodeNameView.text = episode.title
        }
        
        return cell
    }
    
    
}
