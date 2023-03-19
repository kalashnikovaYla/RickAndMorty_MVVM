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
    
    public var shouldShowLoadMoreIndicator: Bool {
            return apiInfo?.next != nil
        }

    public var isLoadingMoreLocations = false

    private var didFinishPagination: (() -> Void)?
    
    init() {
        
    }
    
    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
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
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// Paginate if additional locations are needed
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }
        guard let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreLocations = true

        guard let request = Request(url: url) else {
            isLoadingMoreLocations = false
            return
        }

        NetworkService.shared.execute(request, expecting: GetLocationResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return LocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false

                    // Notify via callback
                    strongSelf.didFinishPagination?()
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreLocations = false
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
