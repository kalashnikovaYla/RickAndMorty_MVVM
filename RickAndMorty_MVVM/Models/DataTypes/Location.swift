//
//  Location.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 10.01.2023.
//

import Foundation

struct Location: Codable {
    
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
