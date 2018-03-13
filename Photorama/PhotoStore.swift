//
//  PhotoStore.swift
//  Photorama
//
//  Created by Kshitij Suthar on 2018-03-12.
//  Copyright © 2018 Kshitij Suthar. All rights reserved.
//

import Foundation

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore{
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchInterestingPhotos(){
        let url = FlickAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(jsonObject)
                }
                
                catch let error {
                    print("Error creating json object: \(error)")
                }
            }
            else if let requestError = error {
                print("Error Fetching interesting photos: \(requestError)")
            }
            else {
                print("Unexpected error with the request")
            }
        }
        
        task.resume()
    }
    
}
