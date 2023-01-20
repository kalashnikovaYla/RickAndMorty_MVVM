//
//  Request.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 11.01.2023.
//

import Foundation

///Object that represents a singlet API call
final class Request {
    //API Constants
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    ///Desired endp oint
    private let endPoint: EndPoint
    ///Path components for API
    private let pathComponents: [String]
    ///Query arguments for API
    private let queryParameters: [URLQueryItem]
    
    
    ///Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap ({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        return string
    }
    
    //MARK: Public
    
    ///Desired http method
    public let httpMethod = "GET"
    
    ///Computed and constructed API url
    public var url: URL? {
        print(URL(string: urlString) ?? "nil")
        return URL(string: urlString)
    }
    
    ///Constructs request
    /// - Parameters:
    ///  - endPoint: Target endpoint
    ///  - pathComponents: Collection of path components
    ///  - queryParameters: Collection of query parameters
    ///
    public init(endPoint: EndPoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    ///Atemp to create request
    ///Request url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/", with: "")
        if trimmed.contains("/") {
            
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] //End points
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let endPoint = EndPoint(rawValue: endpointString) {
                    self.init(endPoint: endPoint, pathComponents: pathComponents)
                    return
                }
            }
             
        } else if trimmed.contains("?"){
            
            let components = trimmed.components(separatedBy: "?")
            
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })
                if let endPoint = EndPoint(rawValue: endpointString) {
                    self.init(endPoint: endPoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
    
}

extension Request {
    static let listCharactersRequest = Request(endPoint: .character)
}
