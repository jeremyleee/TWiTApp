//
//  Show.swift
//  TWiTApp
//
//  Created by Jeremy Lee on 10/06/20.
//  Copyright © 2020 Jeremy Lee. All rights reserved.
//

import Foundation

class Show: Codable {
    let id: Int
    let title: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try Int(container.decode(String.self, forKey: .id)) ?? 0
        title = try container.decode(String.self, forKey: .title)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "label"
    }
}
