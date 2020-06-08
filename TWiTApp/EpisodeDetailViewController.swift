//
//  EpisodeDetailViewController.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 8/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import UIKit
import AVFoundation

class EpisodeDetailViewController: UIViewController {
    
    var episode: Episode!
    
    @IBOutlet var episodeTitleView: UILabel!
    @IBOutlet var showNotesView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = episode.showEpisodeTitle
        episodeTitleView.text = episode.title
        showNotesView.text = episode.showNotes
    }
    
}
