//
//  ViewController.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 7/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var store: TwitDataStore!

    override func viewDidLoad() {
        super.viewDidLoad()        
        store.fetchLatestEpisodes { result in
            switch result {
            case let .success(episodes):
                print("episode count: \(episodes.count)")
            case let .failure(error):
                print("error: \(error)")
            }
        }
    }


}

