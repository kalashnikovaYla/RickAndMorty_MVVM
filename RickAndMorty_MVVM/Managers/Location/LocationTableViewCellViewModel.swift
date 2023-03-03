//
//  File.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 28.01.2023.
//

import Foundation

// чтоб проыерить содержится ли

struct LocationTableViewCellViewModel: Hashable, Equatable {
    
    private let location: Location
    
    init(location: Location) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type: " +  location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
    
    static func == (lhs: LocationTableViewCellViewModel, rhs: LocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
    }
}
