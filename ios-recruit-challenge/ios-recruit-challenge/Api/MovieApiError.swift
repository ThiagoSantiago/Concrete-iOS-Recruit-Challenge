//
//  MovieApiError.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 05/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation

enum MovieApiError: Error {
    case badRequest
    case notFound(GenericResponseString?)
    case unauthorized(GenericResponseString?)
    case unknownResponse
    case invalidJson
    case noInternet
    case erro500
    
    var errorMessage: String {
        switch self {
        case .noInternet:
            return Constants.lostConnectionMessage
        case .notFound(let genericResponseString):
            guard let genericResponse = genericResponseString, let status = genericResponse.message else {
                return Constants.defaultServerFailureError
            }
            return status
        case .unauthorized(let genericResponseString):
            guard let genericResponse = genericResponseString, let status = genericResponse.message else {
                return Constants.defaultServerFailureError
            }
            return status
        default:
            return Constants.defaultServerFailureError
        }
    }
}
