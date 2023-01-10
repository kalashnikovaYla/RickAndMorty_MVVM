//
//  EndPoint.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 11.01.2023.
//

import Foundation

///Represents unique API andpoints
@frozen enum EndPoint: String {
    ///Endpoint to get character info
    case character
    ///Endpoint to get location info
    case location
    ///Endpoint to get episode info
    case episode
}
