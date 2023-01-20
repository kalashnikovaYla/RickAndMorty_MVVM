//
//  GetCharactersResponse.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 11.01.2023.
//

import Foundation

struct GetCharactersResponse: Codable {

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [Character]
}

