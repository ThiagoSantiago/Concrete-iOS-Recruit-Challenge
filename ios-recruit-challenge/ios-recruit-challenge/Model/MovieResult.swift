//
//  MovieResult.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 06/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieResult: Mappable {
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [Movie]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        page <- map["page"]
        totalResults <- map["total_results"]
        totalPages <- map["total_results"]
        results <- map["results"]
    }
}
