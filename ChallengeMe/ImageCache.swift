//
//  ImageCache.swift
//  DylanLab4
//
//  Created by Labuser on 10/14/16.
//  Copyright © 2016 wustl. All rights reserved.
//

import UIKit
struct ImageCache {
    static let imageCacheKey = "ImageCacheKey"
    static let userDefaults = UserDefaults()
    
    static func loadCache() -> [String:UIImage] {
        var imageCache: [String:UIImage] = [:]

        if let dataCache = userDefaults.dictionary(forKey: imageCacheKey) {
            for (key, value) in dataCache {
                let data = value as! NSData
                let image = UIImage(data: data as Data)
                imageCache[key] = image
            }
            return imageCache
        }
        return [String:UIImage]()
    }
    
    static func saveCache(cache: [String:UIImage]) {
        
        var dataCache: [String: NSData] = [:]
        for (key, image) in cache {
            let data = UIImageJPEGRepresentation(image, 1.0)
            dataCache[key] = data as NSData?
        }
        userDefaults.setValue(dataCache, forKey: imageCacheKey)
    }
}
