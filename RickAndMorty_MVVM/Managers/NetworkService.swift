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
    
    private let cacheManager = APICacheManager()
    
    enum ServiceError: Error {
        case faildToCreateRequest
        case faildToGetData
    }
    ///Privatized constructor
    private init() {}
    ///Send Rick and Morty API Call
    /// - Parameters:
    ///  - request: Request instance
    ///  - type: The type of object we expect to get back
    ///  - completion: Callback with data or error
   
    public func execute<T: Codable>(_ request: Request, expecting type: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        
        if let cachedData = cacheManager.cachedResponse(for: request.endPoint, url: request.url) {
            //stop execution
           
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(ServiceError.faildToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.faildToGetData))
                return
            }
            
            //Decode json
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endPoint, url: request.url, data: data)

                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    
    private func request(from request: Request) -> URLRequest? {
        guard let url = request.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
}
