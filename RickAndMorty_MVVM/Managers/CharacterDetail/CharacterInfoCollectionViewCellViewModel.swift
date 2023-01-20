//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 19.01.2023.
//

import Foundation

final class CharacterInfoCollectionViewCellViewModel {
    
    public let value: String
    public let title: String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
    
}
