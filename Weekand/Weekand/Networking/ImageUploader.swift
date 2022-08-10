//
//  ImageUploader.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/29.
//

import Foundation
import UIKit

final class ImageUploader {
    
    func uploadImage(image: UIImage, url: String, filename: String) {

        let url = URL(string: url)
        let session = URLSession.shared
    
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("image/png", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = image.pngData()!

        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            if error == nil {
                print("\(#function): success")
                
            } else {
                print("\(#function): \(String(describing: error))")
            }
        }
        
        task.resume()
        
        
    }
}
