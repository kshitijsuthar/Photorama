//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Kshitij Suthar on 2018-03-12.
//  Copyright © 2018 Kshitij Suthar. All rights reserved.
//

import Foundation

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "3a7524bab72d81e35c6f5f4d20f177e4"
    
    private func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: FlickAPI.baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": FlickAPI.apiKey
        ]
        
        for(key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
        
        //return URL(string:"")!
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            var finalPhotos = [Photo]()
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
   
}




