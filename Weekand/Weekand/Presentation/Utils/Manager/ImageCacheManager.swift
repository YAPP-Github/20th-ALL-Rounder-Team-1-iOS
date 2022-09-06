//
//  ImageCacheManager.swift
//  Weekand
//
//  Created by 이호영 on 2022/08/01.
//

import UIKit

class ImageCacheManager {
    private let cache = NSCache<NSString, UIImage>()
    static let shared = ImageCacheManager()
    
    private init() {}
    
    func loadCachedData(for key: String) -> UIImage? {
        let itemURL = NSString(string: key)
        return cache.object(forKey: itemURL)
    }
    
    func setCacheData(of image: UIImage, for key: String) {
        let itemURL = NSString(string: key)
        cache.setObject(image, forKey: itemURL)
    }
}
