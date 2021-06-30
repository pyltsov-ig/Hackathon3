//
//  ImageDetailsViewController.swift
//  Hackathon3
//
//  Created by ИГОРЬ on 26/06/2021.
//

import UIKit
import Kingfisher

class ImageDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    var photo: PhotoModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo, let url = URL(string: photo.url_z) {
            photoImageView.kf.setImage(with: url)
        }
    }
}
