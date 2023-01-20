//
//  Episode.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 10.01.2023.
//

import Foundation

struct Episode: Codable {
    
    let id: Int  
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
