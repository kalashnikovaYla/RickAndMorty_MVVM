//
//  CharacterEpisodeCollectionViewCell.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 18.01.2023.
//

import UIKit

class CharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CharacterEpisodesCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    public func configure(with viewModel: CharacterEpisodeCollectionViewCellViewModel) {
        
    }
}
