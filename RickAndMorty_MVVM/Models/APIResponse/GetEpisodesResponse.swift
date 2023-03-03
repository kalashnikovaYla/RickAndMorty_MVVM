//
//  GetEpisodesResponse.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 22.01.2023.
//

import Foundation

struct GetEpisodesResponse: Codable {

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [Episode]
}
