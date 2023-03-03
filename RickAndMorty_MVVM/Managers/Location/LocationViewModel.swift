//
//  LocationViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 26.01.2023.
//

import Foundation

protocol LocationViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}


final class LocationViewModel {
    
    weak var delegate: LocationViewModelDelegate?
    
    private var locations: [Location] = [] {
        didSet {
            for location in locations {
                let cellViewModel = LocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    //Location response info
    public private(set) var cellViewModels: [LocationTableViewCellViewModel] = []
    
    private var apiInfo: GetLocationResponse.Info?
    
    
    init() {
        
    }
    public func fetchLocations() {
        NetworkService.shared.execute(.listLocationsRequest, expecting: GetLocationResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    // !!! чтоб не давать доступ ко всему массиву
    public func location(at index: Int) -> Location? {
        guard index < locations.count, index >= 0 else {return nil}
        return self.locations[index]
    }
    
    public var hasMoreResults: Bool {
        return false
    }
}
