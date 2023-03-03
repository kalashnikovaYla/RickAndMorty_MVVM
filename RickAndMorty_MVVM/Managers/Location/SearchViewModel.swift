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
    private var searchResultHandler: (() -> Void)?
    
    private var searchText = ""
    
    //MARK: - Init
    
    init(config: SearchViewController.Config) {
        self.config = config
    }
    
    //MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
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
        

        // Test search text
        searchText = "Rick"

        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText)
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

        print(request.url?.absoluteString)

        NetworkService.shared.execute(request, expecting: GetCharactersResponse.self) { result in
        
            // Notify view of results, no results, or error
            switch result {
            case .success(let model):
                print("Search results found: \(model.results.count)")
            case .failure:
                break
            }
        }
    }
}
