//
//  Model.swift
//  Hackathon3
//
//  Created by ИГОРЬ on 26/06/2021.
//

import Foundation
import SwiftyJSON


class PhotoModel{
    var url_o:String
    var url_q:String
    var url_z:String
    
    init(photosDictionary: JSON) {
        self.url_o = photosDictionary["url_o"].stringValue
        self.url_q = photosDictionary["url_q"].stringValue
        self.url_z = photosDictionary["url_z"].stringValue
    }
}

