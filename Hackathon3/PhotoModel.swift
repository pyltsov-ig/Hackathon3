//
//  Model.swift
//  Hackathon3
//
//  Created by ИГОРЬ on 26/06/2021.
//

import Foundation
import SwiftyJSON


class PhotoModel{
    var url_z:String
    var url_q:String
    //var width_q:CGFloat
    
    init(photosDictionary: JSON) {
        self.url_z = photosDictionary["url_z"].stringValue
        self.url_q = photosDictionary["url_q"].stringValue
      //  self.width_q = CGFloat(photosDictionary["width_q"].floatValue)
       
    }
}

