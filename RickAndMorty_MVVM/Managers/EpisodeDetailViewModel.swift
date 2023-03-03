//
//  EpisodeDetailViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 22.01.2023.
//

import UIKit

protocol EpisodeDetailViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class EpisodeDetailViewModel {
    
    //MARK: - Private
    
    private let endpointURL: URL?
    private var dataTuple: (episode: Episode, characters: [Character])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    //MARK: - Public
    
    public weak var delegate: EpisodeDetailViewModelDelegate?
    
    // public private(set) - общедоступна но не для записи в нее
    public private(set) var cellViewModels: [SectionType] = []
    
    enum SectionType {
        case information(viewModels: [EpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [CharacterCollectionViewCellViewModel])
    }
    
    //MARK: - Init
    
    init(url: URL?) {
        self.endpointURL = url
    }
    
    //MARK: - Public
    
    public func character(at index: Int) -> Character? {
        guard let dataTuple = dataTuple else {return nil}
        return dataTuple.characters[index]
    }
    
    
    ///Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointURL, let request = Request(url: url) else {return}
        
        NetworkService.shared.execute(request, expecting: Episode.self) { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model )
            case .failure:
                break
            }
        }
    }
    
    //MARK: - Private
    
    private func fetchRelatedCharacters(episode: Episode) {
        let charactersURL: [URL] = episode.characters.compactMap({
            return URL(string: $0)
        })
        let request: [Request] = charactersURL.compactMap({
            return Request(url: $0)
        })
        var characters: [Character] = []
        
        let group = DispatchGroup()
        for request in request {
            group.enter()
            NetworkService.shared.execute(request, expecting: Character.self) { result in
                
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
            group.notify(queue: .main) {
                self.dataTuple = (
                    episode: episode,
                    characters: characters
                )
            }
        }
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {return}
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if let date = CharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = CharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date) 
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode name", value: episode.name),
                .init(title: "Air date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString)
            ]),
            .characters(viewModel: characters.compactMap({ character in
                
                return CharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
        
    }
}
