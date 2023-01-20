//
//  CharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 19.01.2023.
//

import Foundation

final class CharacterPhotoCollectionViewCellViewModel{
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data,Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
            
        }
        ImageLoader.shared .downloadImage(imageUrl, completion: completion)
    }
    
}
