//
//  ImageDetailsViewController.swift
//  Hackathon3
//
//  Created by ИГОРЬ on 26/06/2021.
//

import UIKit
import Kingfisher

class ImageDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: UIImageView!
    var photo: PhotoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue.global(qos: .background)
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        queue.async {
            if let photo = self.photo, let url = URL(string: photo.url_o),let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.photoImageView.image = UIImage(data: imageData)
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.photoImageView.image = UIImage(named: "no_image")
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true

                }
            }
        }
    }
}
 
