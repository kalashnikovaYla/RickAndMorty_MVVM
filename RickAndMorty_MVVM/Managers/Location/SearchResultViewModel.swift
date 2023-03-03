//
//  SearchResultViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 03.03.2023.
//

import Foundation

enum SearchResultViewModel {
    case characters([CharacterCollectionViewCellViewModel])
    case locations([LocationTableViewCellViewModel])
    case episodes([CharacterEpisodeCollectionViewCellViewModel])
}
