//
//  CharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 19.01.2023.
//

import Foundation
import UIKit

protocol EpisodeDataRender {
    var name: String {get}
    var air_date: String {get }
    var episode: String {get}
}

final class CharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var episode: Episode? {
        didSet {
            guard let model = episode else {return}
            dataBlock?(model)
        }
    }
    private var dataBlock: ((EpisodeDataRender) -> Void)?
    
    public var borderColor: UIColor
     
    //MARK: Init
    
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    //MARK: Public
    
    public func registerForData(_ block: @escaping(EpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl, let request = Request(url: url) else {return}
        
        isFetching = true
        NetworkService.shared.execute(request, expecting: Episode.self) { [weak self] result in
            switch result {
            case .success(let episode):
                DispatchQueue.main.async {
                    self?.episode = episode
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func == (lhs: CharacterEpisodeCollectionViewCellViewModel, rhs: CharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
   
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
}
