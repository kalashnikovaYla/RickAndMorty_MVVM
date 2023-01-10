//
//  NetworkService.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 11.01.2023.
//

import Foundation

///API Service object to get Rick and Morty data
final class NetworkService {
    ///Shared singleton instance
    static let shared = NetworkService()
    
    ///Privatized constructor
    private init() {}
    ///Send Rick and Morty API Call
    /// - Parameters:
    /// - request: Request instance
    /// - completion: Callback with data or error
    public func execute(_ request: Request, completion: @escaping() -> Void) {
         
    }
}
