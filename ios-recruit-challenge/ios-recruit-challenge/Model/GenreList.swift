//
//  GenreList.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 06/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import ObjectMapper

class GenreList: Mappable {
    var genres: [Genre]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        genres <- map["genres"]
    }
}
