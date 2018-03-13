//
//  PhotoStore.swift
//  Photorama
//
//  Created by Kshitij Suthar on 2018-03-12.
//  Copyright © 2018 Kshitij Suthar. All rights reserved.
//  Project By:
//      Kshitij Suthar (300971838)
//      Yash Sompura   (300967186)
//

import Foundation
import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore{
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void){
        let url = FlickAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processPhotoRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            completion(result)
//            if let jsonData = data {
//                do {
//                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                    print(jsonObject)
//                }
//
//                catch let error {
//                    print("Error creating json object: \(error)")
//                }
//            }
//            else if let requestError = error {
//                print("Error Fetching interesting photos: \(requestError)")
//            }
//            else {
//                print("Unexpected error with the request")
//            }
        }
        
        task.resume()
    }
    
    private func processPhotoRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickAPI.photos(fromJSON: jsonData)
    }
    
    func fetchImage(for photo:Photo, completion: @escaping (ImageResult) -> Void){
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            completion(result)
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                
                if data == nil {
                    return .failure(error!)
                }
                else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }
    
}
