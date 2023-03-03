//
//  SearchViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 01.02.2023.
//

import Foundation

///Resposibilities
/// - show the search results
/// - show no results view
/// - kick off API request

final class SearchViewModel {
    
    let config: SearchViewController.Config
    
    private var optionMap: [SearchInputViewModel.DynamicOption: String] = [:]
     
    private var optionMapUpdateBlock: (((SearchInputViewModel.DynamicOption, String)) -> Void)?
    private var searchResultHandler: ((SearchResultViewModel) -> Void)?
    
    private var searchText = ""
    
    //MARK: - Init
    
    init(config: SearchViewController.Config) {
        self.config = config
    }
    
    //MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (SearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: SearchInputViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping((SearchInputViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
    
    public func executeSearch() {
        //Create request
        //Send API Call
        //Notify view of results, no results or error
        

        print("Search \(searchText)")
        // Test search text
        

        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: SearchInputViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))

        // Create request
        let request = Request(
            endPoint: config.type.endpoint,
        queryParameters: queryParams
        )

        switch config.type.endpoint {
        case .character:
            makeSearchApiCall(GetCharactersResponse.self, request: request)
        case .episode:
            makeSearchApiCall(GetEpisodesResponse.self, request: request)
        case .location:
            makeSearchApiCall(GetLocationResponse.self, request: request)
        }
        
    }
    
    private func makeSearchApiCall<T: Codable>(_ type: T.Type, request: Request) {
        NetworkService.shared.execute(request, expecting: type) { [weak self] result in
        
            // Notify view of results, no results, or error
            switch result {
            case .success(let model):
                
                //Episodes, Characters - Collection View, Location - tableView
                
                self?.processSearchResult(model: model)
            case .failure:
                break
            }
        }
    }
    
    private func processSearchResult(model: Codable) {
        
        var resultsVM: SearchResultViewModel?
        
        if let characterResults = model as? GetCharactersResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                
                return CharacterCollectionViewCellViewModel(characterName: $0.name,
                                                            characterStatus: $0.status,
                                                            characterImageUrl: URL(string: $0.url))
            }))
            
        } else if let episodeResults = model as? GetEpisodesResponse {
            resultsVM = .episodes(episodeResults.results.compactMap({
                return CharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
            
        } else if let locationsResults = model as? GetLocationResponse {
            resultsVM = .locations(locationsResults.results.compactMap({
                return LocationTableViewCellViewModel(location: $0)
            }))
            
        }
        
        if let results = resultsVM {
            self.searchResultHandler?(results)
        } else {
            
        }
    }
}
