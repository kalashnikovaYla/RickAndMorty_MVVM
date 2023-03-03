//
//  APICacheManager.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 22.01.2023.
//

import Foundation

///Manages in memory session scoped API caches 
final class APICacheManager {
    
    //API URL: Data
    // NSCache автоматически обрабатывает освобождения кеша в памяти
    private var cache = NSCache<NSString, NSData>()
    
    private var cacheDictionary: [EndPoint: NSCache<NSString, NSData>] = [:]
   
    init() {
         setUpCache()
    }
    
    public func setCache(for endpoint: EndPoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {return}
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    // Функции, позволяющие проверять доступно ли что то в кэше
    public func cachedResponse(for endpoint: EndPoint, url: URL?) -> Data? {
        
        guard let targetCache = cacheDictionary[endpoint], let url = url else {return nil}
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    private func setUpCache() {
        EndPoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
