//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Kshitij Suthar on 2018-03-12.
//  Copyright © 2018 Kshitij Suthar. All rights reserved.
//  Project By:
//      Kshitij Suthar (300971838)
//      Yash Sompura   (300967186)
//


import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageview: UIImageView!
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
            
        }
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (imageResult) -> Void in
            
            switch imageResult {
            case let .success(image):
                self.imageview.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
}
