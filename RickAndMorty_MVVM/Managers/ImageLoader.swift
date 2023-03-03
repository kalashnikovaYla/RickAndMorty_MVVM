//
//  ImageLoader.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 15.01.2023.
//

import Foundation

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    // Разумно справляется с исправлением от кэша в вашем сеансе, в вашей памяти, в сеансе вашего приложения на случай, если памяти становится мало
    private var imageDataCache = NSCache<NSString, NSData>()
    
    
    private init() {}
    
    
    ///Get image content with URL
    /// - Parameters:
    ///  - url: Source url
    ///  - completion: Callback
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>)->Void) {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data ))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let key = url.absoluteString as NSString
            let value = data as NSData
            self? .imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
