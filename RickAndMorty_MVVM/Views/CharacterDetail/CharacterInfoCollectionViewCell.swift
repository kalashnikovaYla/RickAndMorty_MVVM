//
//  CharacterInfoCollectionViewCell.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 18.01.2023.
//

import UIKit

class CharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "CharacterInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    public func configure(with viewModel: CharacterInfoCollectionViewCellViewModel) {
        
    }
}
