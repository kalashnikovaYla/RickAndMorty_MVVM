//
//  LocationDetailViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 01.02.2023.
//

import Foundation
import UIKit


protocol LocationDetailViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class LocationDetailViewModel {
    
    //MARK: - Private
    
    private let endpointURL: URL?
    private var dataTuple: (location: Location, characters: [Character])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    //MARK: - Public
    
    public weak var delegate: LocationDetailViewModelDelegate?
    
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
    
    
    ///Fetch backing location model
    public func fetchLocationData() {
        guard let url = endpointURL, let request = Request(url: url) else {return}
        
        NetworkService.shared.execute(request, expecting: Location.self) { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model )
            case .failure:
                break
            }
        }
    }
    
    //MARK: - Private
    
    private func fetchRelatedCharacters(location: Location) {
        let charactersURL: [URL] = location.residents.compactMap({
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
                    location: location,
                    characters: characters
                )
            }
        }
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {return}
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdString = location.created
        if let date = CharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = CharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
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
