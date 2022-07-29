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

        let boundary = UUID().uuidString
        let session = URLSession.shared
    
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"

        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                print("\(#function): success")
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            } else {
                print("\(#function): \(error)")
            }
        }).resume()
    }
}
