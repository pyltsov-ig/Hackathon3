//
//  Constants.swift
//  Hackathon3
//
//  Created by ИГОРЬ on 28/06/2021.
//

import Foundation

let baseUrl = "https://www.flickr.com/services/rest/"

var parameters = [
    "method" : "flickr.interestingness.getList",
    "api_key" : "83adf9384234a94f66f74f6134b3002f",
    "sort" : "relevance",
    "per_page" : "21",
    "format" : "json",
    "nojsoncallback" : "1",
    "extras" : "url_q, url_z",
    "page":"2"
    ]


