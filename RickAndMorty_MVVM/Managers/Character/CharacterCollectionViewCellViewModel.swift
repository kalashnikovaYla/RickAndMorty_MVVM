//
//  CharacterCollectionViewCellViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 13.01.2023.
//

import Foundation

final class CharacterCollectionViewCellViewModel: Hashable, Equatable {
    
    
    public let characterName: String
    private let characterStatus: CharacterStatus
    private let characterImageUrl: URL?
    
    
    //MARK: Init
    
    init(characterName: String, characterStatus: CharacterStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping(Result<Data, Error>) -> Void) {
        
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        //let request = URLRequest(url: url)
        ImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    //MARK: Hashable
    
    // Скомбинруй имя статус
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
    
    
    static func == (lhs: CharacterCollectionViewCellViewModel, rhs: CharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
