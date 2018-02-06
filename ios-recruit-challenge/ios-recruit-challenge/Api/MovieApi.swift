//
//  MovieApi.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 05/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

enum MovieApi {
    case getPopularMovies()
}

extension MovieApi {
    var baseUrl: String {
        return Constants.baseUrl
    }
    
    var path: String {
        switch self {
            
        case .getPopularMovies():
            return "movie/popular?api_key=\(Constants.apiKey)&language=pt-BR&page=1"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
            
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
            
        default:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case _ where self.method == .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        var defaultHeaders = [String: String]()
        
        switch self {
        default:
            defaultHeaders["Content-Type"] = "application/json"
            return defaultHeaders
        }
    }
}

extension MovieApi {
    static func request<T: Mappable>(_ endpoint: MovieApi, completion: @escaping (_ result: Result<T>) -> Void) {
        
        Alamofire.request("\(endpoint.baseUrl)\(endpoint.path)", method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding, headers: endpoint.headers).responseJSON { (httpResponse: DataResponse<Any>) in
            
            guard let response = httpResponse.response else {
                completion(Result.failure(MovieApiError.unknownResponse))
                return
            }
            
            completion(self.handler(statusCode: response.statusCode, dataResponse: httpResponse))
        }
    }
    
    private static func handler<T: Mappable>(statusCode: Int, dataResponse: DataResponse<Any>) -> Result<T> {
        
        switch statusCode {
        case 200...299:
            let responseJson = dataResponse.result.value as? [String: Any]
            
            return parseJson(responseJson)
        case 400:
            guard let errorArray = dataResponse.result.value as? [[String: Any]] else {
                return Result.failure(MovieApiError.unknownResponse)
            }
            
            var errors = ""
            
            for error in errorArray {
                let errorMessage = error["mensagem"] as? String ?? ""
                
                errors.append("\(errorMessage); ")
            }
            
            let genericResponse = GenericResponseString()
            genericResponse.message = errors
            
            return Result.failure(MovieApiError.badRequest(genericResponse))
        case 401:
            return Result.failure(MovieApiError.unauthorized)
        case 404:
            return Result.failure(MovieApiError.notFound)
        default:
            return Result.failure(MovieApiError.unknownResponse)
        }
    }
    
    private static func parseJson<T: Mappable>(_ responseJson: [String: Any]?) -> Result<T> {
        
        if let json = responseJson {
            guard let object = T(JSON: json) else {
                return Result.failure(MovieApiError.invalidJson)
            }
            
            return Result.success(object)
        } else {
            guard let object = T(JSON: responseJson ?? [:]) else {
                return Result.failure(MovieApiError.invalidJson)
            }
            
            return Result.success(object)
        }
    }
}
