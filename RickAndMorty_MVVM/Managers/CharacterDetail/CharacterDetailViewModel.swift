//
//  CharacterDetailViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 14.01.2023.
//

import UIKit

final class CharacterDetailViewModel {
    
    private let character: Character
    
    enum SectionType {
        case photo(viewModel: CharacterPhotoCollectionViewCellViewModel)
        case information(viewModels: [CharacterInfoCollectionViewCellViewModel])
        case episodes(viewModels: [CharacterEpisodeCollectionViewCellViewModel])
        
    }
    public var sections: [SectionType] = []
    
    public var episodes: [String] {
        character.episode
    }
    
    //MARK: Init
    
    init(character: Character) {
        self.character = character
        setupSections()
    }
    
    private func setupSections(){
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status, value: character.status.rawValue),
                .init(type: .gender,value: character.gender.rawValue),
                .init(type: .type,value: character.type),
                .init(type: .species,value: character.species),
                .init(type: .origin,value: character.origin.name),
                .init(type: .location,value: character.location.name),
                .init(type: .created,value: character.created),
                .init(type: .episodeCount,value: "\(character.episode.count)")
            ]),
            .episodes(viewModels: character.episode.compactMap ({
                return CharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
        ]
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
    //MARK: Layouts
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150.0)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    
    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150.0)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
}


/*
public func fetchCharacterInfo() {
    guard let url = requestUrl, let request = Request(url: url) else {return}
    
    NetworkService.shared.execute(request, expecting: Character.self) { result in
        switch result {
        case .success(let data):
            print(String(describing: data))
        case .failure(let error):
            print(String(describing: error))
        }
    }
}
 */
