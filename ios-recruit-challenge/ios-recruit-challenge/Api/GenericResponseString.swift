//
//  GenericResponseString.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 05/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import ObjectMapper

final class GenericResponseString: Mappable {
    var errorCode: String?
    var message: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        errorCode <- map["status_code"]
        message <- map["status_message"]
    }
}
