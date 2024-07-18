//
//  DetailedPostCell.swift
//  Unit2ProjectBeRealClone
//
//  Created by Raymond Chen on 7/17/24.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import CoreLocation

class DetailedPostCell: UITableViewCell {
    private var imageDataRequest: DataRequest?
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configure(with post: Post) {
        // Username
        if let user = post.user {
            usernameLabel.text = user.username
        }
        // Image
        if let imageFile = post.imageFile,
           let imageUrl = imageFile.url {
            
            // Use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageUrl).responseImage { [weak self] response in
                switch response.result {
                case .success(let image):
                    // Set image view image with fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("❌ Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        
        
        // Caption
        captionLabel.text = post.caption

        // Date
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
        
        // Location
        if let location = post.location?.toCLLocation {
            let geocoder = CLGeocoder()
             geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    self.locationLabel.text = firstLocation?.name
                }
                else {
                 // An error occurred during geocoding.
                    self.locationLabel.text = "No location found"
                }
            })
        } else {
            self.locationLabel.text = "No location found"
        }
        
    }
}
