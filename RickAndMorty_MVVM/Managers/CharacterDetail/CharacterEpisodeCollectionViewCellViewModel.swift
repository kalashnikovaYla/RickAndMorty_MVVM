//
//  CharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 19.01.2023.
//

import Foundation

final class CharacterEpisodeCollectionViewCellViewModel {
   
    private let episodeDataUrl: URL?
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
}
